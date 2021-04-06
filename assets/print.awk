BEGIN {
  FS=":"
  printf "processing /etc/passw"
}
{
  printf "username: " $1 "\t user id:" $3 "\n"
  printf NF "\n"
}
END {
  printf "All done processing /etc/passwd\n"
  printf FILENAME "\n"
}
