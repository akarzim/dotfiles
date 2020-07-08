# aws
if program "aws"; then
  decipher ${0:A:h:h}/home/aws/config.gpg .aws/config
else
  skip "aws"
fi
