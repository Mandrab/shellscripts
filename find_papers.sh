# search for non-cited papers
#!/bin/bash

BIB_FILE=$1
PAPER_FOLDER=$2

if [ ! -e "$BIB_FILE" ]; then
	echo "No bib file provided"
	exit
fi

if [ ! -d "$PAPER_FOLDER" ]; then
	echo "No papers-folder provided"
	exit
fi

printf "Search for papers in \"$PAPER_FOLDER\" that have not been cited in \"$BIB_FILE\"\n\n"

# find pdf files
PDF_FILES=$(find "$PAPER_FOLDER" -iname "*.pdf" -exec basename {} .pdf ';' |  awk -F'/?' '{print $NF}' | tr '[:upper:]' '[:lower:]' | sort | uniq)

# find cited papers
CITED_PAPERS=$(cat "$BIB_FILE" | grep " title" | awk -F'title *= *{|}' '{print $2}' | tr '[:upper:]' '[:lower:]'  | sort | uniq)

# remove cited papers from list
NOT_CITED_PAPERS=$(diff -i <(echo "$CITED_PAPERS") <(echo "$PDF_FILES") | grep ">" | awk -F'> ' '{print $2}')

# find ignored papers
if [ -f ".paper_ignore" ]; then
	IGNORED_PAPERS=$(cat .paper_ignore)
	NOT_CITED_PAPERS=$(diff -i <(echo "$IGNORED_PAPERS") <(echo "$NOT_CITED_PAPERS") | grep ">" | awk -F'> ' '{print $2}')
fi

# set internal line separator as \n instead of space
IFS=$'\n'

# cicle each file
printf "All the non cited papers will be shown below one by one.\nPress enter to continue. Press ctrl + c to exit\n\n"
for FILE in $NOT_CITED_PAPERS; do
	FILE_PATH=$(find "$PAPER_FOLDER" -type f -iname "$FILE.pdf")
	printf "file: $FILE\nlocation: $FILE_PATH\n"
	read -p "" X

	# if the user type 'o' open the note of the file
	if [ "$X" == "o" ]; then
		xournalpp "$FILE_PATH" > /dev/null 2>&1
	fi
done
