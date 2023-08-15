resource "aws_instance" "web" {
  ami                    = var.aws_ami
  instance_type          = var.instanceType
  key_name               = aws_key_pair.awskey.key_name
  vpc_security_group_ids = [aws_security_group.security_group.id]

  tags = {
    Name = "aws-first-instance-by-terraform"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/awskey")
    host        = self.public_ip
    agent       = true
  }

  # # Copy file to VM
  # provisioner "file" {
  #   when = create
  #   on_failure = fail
  #   destination = "~/user-data.sh"
  #   source      = "user-data.sh"
  # }

  # # Add executable rights
  # provisioner "local-exec" {
  #   when = create
  #   on_failure = fail
  #   command = "chmod +x ./user-data.sh"
  # }

  # # Execute file on VM
  # provisioner "local-exec" {
  #   when = create
  #   on_failure = fail
  #   command = "./user-data.sh"
  # }

  provisioner "remote-exec" {
    on_failure = fail
    when       = create
    script     = "./user-data.sh"
  }

}