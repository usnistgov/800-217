#!/usr/bin/env bash

me=$(basename "$0")

help_message="\
Usage: $me [-c FILE] [<options>] <action>
Synchronize local files from a git branch on another repository.

Options:

  -h, --help               Show this help information.
  -v, --verbose            Increase verbosity. Useful for debugging.
  -e, --allow-empty        Allow deployment of an empty directory.
  -m, --message MESSAGE    Specify the message used when committing on the
                           deploy branch.
  -n, --no-hash            Don't append the source commit's hash to the deploy
                           commit's message.
  -c, --config-file PATH   Override default & environment variables' values
                           with those in set in the file at 'PATH'. Must be the
                           first option specified.

Actions:

  init             forcibly clear and initialize sync directory from repository
  fetch            download updates into sync directory from repository
  compare          compare sync directory contents to local space
  update           copy changes from sync directory into local space
  export           copy changes from local space into sync directory
  utils            compare utility scripts

Variables:

  GIT_SYNC_DIR      Folder path containing the files to sync from.
  GIT_SYNC_ROOT     Folder path containing the files to sync to.
  GIT_SYNC_BRANCH   Pull synchronized files from this branch.
  GIT_SYNC_REPO     Pull the sync branch from this repository.

Paths:

  GIT_SYNC_TEMPLATES   Folder path containing template files.
  GIT_SYNC_UTILS       Folder path containing utility files.
  GIT_SYNC_ALLOWED_TEMPLATES
                       Space-separated template directories that 'update' and
                       'export' may copy. (Default: _includes _layouts
                       _pdftemplate static)

These variables have default values defined in the script. The defaults can be
overridden by environment variables. Any environment variables are overridden
by values set in a '.env' file (if it exists), and in turn by those set in a
file specified by the '--config-file' option."

parse_args() {
	# Set args from a local environment file.
	if [ -e ".env" ]; then
		source .env
	fi

	# Set args from file specified on the command-line.
	if [[ $1 = "-c" || $1 = "--config-file" ]]; then
		source "$2"
		shift 2
	fi

	# Parse arg flags
	# If something is exposed as an environment variable, set/overwrite it
	# here. Otherwise, set/overwrite the internal variable instead.
	while : ; do
		if [[ $1 = "-h" || $1 = "--help" ]]; then
			echo "$help_message"
			return 0
		elif [[ $1 = "-v" || $1 = "--verbose" ]]; then
			verbose=true
			shift
		elif [[ $1 != "" && $action = "" ]]; then
			action=$1
			shift
		else
			break
		fi
	done
	
	if [[ $action = '' ]]; then
		echo "Specifying an <action> is required."
		echo "$help_message"
		return 1
	fi
	
	# Set internal option vars from the environment and arg flags. All internal
	# vars should be declared here, with sane defaults if applicable.

	# Source directory & target branch.
	sync_directory=${GIT_SYNC_DIR:-_template_workspace}
	sync_branch=${GIT_SYNC_BRANCH:-main}
	sync_remote=${GIT_SYNC_REMOTE:-template}
	sync_root=${GIT_SYNC_ROOT:-.}
	sync_templates=${GIT_SYNC_TEMPLATES:-templates}
	sync_utils=${GIT_SYNC_UTILS:-utils}
	sync_allowed_templates=${GIT_SYNC_ALLOWED_TEMPLATES:-_includes _layouts _pdftemplate static}

	#repository to pull from. must be readable.
	repo=${GIT_SYNC_REPO:-https://github.com/usnistgov/nistpages-doc-template.git}
}

main() {
	parse_args "$@"

	previous_branch=`git rev-parse --abbrev-ref HEAD`

	if [[ $action = "init" ]]; then
		initialize_sync_directory
	elif [[ $action = "fetch" ]]; then
		update_sync_directory
	elif [[ $action = "compare" ]]; then
		compare_templates
	elif [[ $action = "utils" ]]; then
		compare_utils
	elif [[ $action = "update" ]]; then
		update_from_sync_directory
	elif [[ $action = "export" ]]; then
		update_to_sync_directory
	fi
}

initialize_sync_directory() {
	if [ -d "$sync_directory" ]; then
		echo "Removing old sync directory $sync_directory ..."
		rm -rfv -- "$sync_directory"
	fi
	git clone -o "$sync_remote" -- "$repo" "$sync_directory"
}

update_sync_directory() {
	git -C "$sync_directory" checkout "$sync_branch"
	git -C "$sync_directory" pull "$sync_remote" "$sync_branch"
}

compare_templates() {
	compare_sync_directory "$sync_templates"
}

compare_utils() {
	compare_sync_directory "$sync_utils"
}

# Only accept plain names from the sync repository: no leading dash,
# whitespace, or path separators.
is_safe_name() {
	[[ -n $1 && $1 != -* && $1 != .* && $1 =~ ^[A-Za-z0-9._-]+$ ]]
}

# Only these top-level template directories are copied into the local space.
is_allowed_template() {
	local allowed
	for allowed in $sync_allowed_templates; do
		[[ $1 = "$allowed" ]] && return 0
	done
	return 1
}

compare_sync_directory() {
	if [ -z "$1" ]; then
		echo "Missing sync directory."
		return 1
	fi
	diffs=()
	for f in "$sync_directory/$1"/*
	do
		[ -e "$f" ] || continue
		name=${f##*/}
		if ! is_safe_name "$name"; then
			echo "Skipping unsafe name: $(printf '%q' "$name")" >&2
			continue
		fi
		echo "Comparing $name ..."
		if [ -d "$sync_root/$name" ]; then
			trail='/'
		else
			trail=''
		fi
		if [[ $verbose ]]; then
			diff -Naur -- "$f$trail" "$sync_root/$name$trail"
		else
			diff -Naqr -- "$f$trail" "$sync_root/$name$trail"
		fi
		if [[ $? -ne 0 ]]; then
			diffs+=("$name")
		fi
	done

	if [ ${#diffs[@]} -ne 0 ]; then
		echo
		echo "There were differences in: ${diffs[*]}"
		echo
		echo "Run '$me update' to pull in changes."
	else
		echo "Everything is up to date."
	fi
}

# Run rsync on one allowlisted template directory. Arguments: source, destination.
sync_template_directory() {
	if [[ $verbose ]]; then
		rsync -rcv --delete --exclude .git -- "$1" "$2"
	else
		rsync -rc --delete --exclude .git -- "$1" "$2"
	fi
}

update_from_sync_directory() {
	for f in "$sync_directory/$sync_templates"/*
	do
		[ -d "$f" ] || continue
		name=${f##*/}
		if ! is_safe_name "$name" || ! is_allowed_template "$name"; then
			echo "Skipping $(printf '%q' "$name"): not an allowed template directory" >&2
			continue
		fi
		echo "Synchronizing $name ..."
		sync_template_directory "$f/" "$sync_root/$name/"
	done
	compare_sync_directory "$sync_templates"
}

update_to_sync_directory() {
	for f in "$sync_directory/$sync_templates"/*
	do
		[ -d "$f" ] || continue
		name=${f##*/}
		if ! is_safe_name "$name" || ! is_allowed_template "$name"; then
			echo "Skipping $(printf '%q' "$name"): not an allowed template directory" >&2
			continue
		fi
		echo "Synchronizing $name ..."
		sync_template_directory "$sync_root/$name/" "$f/"
		git -C "$sync_directory" status
	done
	compare_sync_directory "$sync_templates"
}

[[ $1 = --source-only ]] || main "$@"
