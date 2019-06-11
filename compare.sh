#!/bin/bash
# Compare results unit tests executions, for instance between several source control branches.

# Difference viewing tool.
# meld is conveniently shows what what status has changed, while diff is better for further command line processing.
DIFF=meld

# List containing the filenames of the output for each input file.
PROCESSED=""

for FILE in "$@"
do
	echo "Processing $FILE"

	# Name of the output file
	OUTPUT="${FILE}.processed"

	sed -e "s/Result[0-9]* //" $FILE \
		| grep "Name:\|Outcome:" \
		| tr "\n" " " \
		| sed -e "s/Name:/\nName:/g" \
		| sed -e "s/(.*)//g" \
		| sed -e "s/Outcome://g" \
		| sed -e "s/Name:\t//g" \
		| sort \
		> $OUTPUT

	# Add result to the list
	PROCESSED="${PROCESSED} ${OUTPUT}"
done

# Output the difference.
$DIFF $PROCESSED

# Exit using status of the diff, allowing further use, for instance for continuous integration.
exit $?
