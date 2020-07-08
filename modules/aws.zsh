# aws
if program "aws"; then
  decipher ${0:A:h:h}/home/aws/config.gpg .aws/config
  decipher ${0:A:h:h}/home/ecs/config.gpg .ecs/config
else
  skip "aws"
fi
