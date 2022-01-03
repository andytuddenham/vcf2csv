#! /usr/bin/awk -f

BEGIN {
#	Set the input field seperator to a :
	FS = ":"
#	Set the record seperator to an LF preceeded by an optional CR
#	NB. Windows uses CRLF, Unix uses LF
	RS = "\r?\n"
#	Set the output field seperator to a comma
	OFS = ","
#	Set variable to hold number of output lines produced
	count = 0
#	print header record
	line = "Name" OFS "F Name" OFS "Nickname" OFS "Telephone" OFS "Email"
	print line > "vcf2csv.csv"
}

# A line beginning with "BEGIN" is the first line
/^BEGIN/ {
#	clear fields to start a new record
	name = ""
	fname = ""
	nname = ""
	tel = ""
	email = ""
}

# A line beginning with "N:" contains the Name
/^N:/ {
	name = $2
}

# A line beginning with "FN:" contains the F Name
/^FN:/ {
	fname = $2
}

# A line beginning with "NICKNAME:" contains the Nickname
/^NICKNAME:/ {
	nname = $2
}

# A line beginning with "TEL;" contains a telephone number
/^TEL;/ {
	tel ? tel = tel " / " $2 : tel = $2
}

# A line beginning with "EMAIL;" contains an email address
/^EMAIL;/ {
	email ? email = email " / " $2 : email = $2
}

# A line beginning with "END:" is the last line
/^END:/ {
#	Create a new record from the fields collected
	line = name OFS fname OFS nname OFS tel OFS email
#	Print the completed output line to the csv file
	print line > "vcf2csv.csv"
#	Increment count of lines produced
	count++
}

END {
#	Print statistics for this run
	print "Processed " NR " lines of input and produced " count " lines of output."
}
