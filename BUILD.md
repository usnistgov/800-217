# Build Instructions

This document source is formatted with Markdown and uses Docker to enable building the final document in both HTML and PDF formats.

To build the HTML website and run a local server, use the command:

~~~
docker-compose up
~~~

This will start a local Jekyll server which will be available on <http://localhost:4000/800-217/>.

To build the PDF document, use the command:

~~~
docker-compose -f docker-compose-pdf.yml up
~~~

This will build a PDF file found in `_pdf/800-217/800-217.pdf`.

The source of the can be document is separated into parts, each in a different source directory:

* `sp800-217` contains all sections of the core document text.

Within these directories, each section of the document has its own source file.
