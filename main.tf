provider "aws" {
  access_key = "AKIAXUU6JOBIRMHFO2UD"
  secret_key = "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"
  region     = "us-west-1"
}

variable "privatekey" {
  default = "/etc/ansible/mastercal.pem"
}
resource "aws_security_group" "splunk" {
  name        = "splunk"
  description = "Created by terraform"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = "ami-03f6d497fceb40069"
  key_name      = "mastercal"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.splunk.name}"]
    #connection {
    #host        = "${self.public_ip}"
    #type        = "ssh"
    #user        = "ubuntu"
    #private_key = file("mastercal.pem")
  #}

  tags = {
    Name = "Prod"
  }
  #provisioner "remote-exec" {
   # inline = [
    #  "ping -c 10 8.8.8.8",
     # "curl -sSL https://raw.githubusercontent.com/ashwini1331/jenkinsbuild/main/jenkins.sh | bash",
    #]
  #}

#  provisioner "local-exec" {
 #   command = "ansible-playbook -u ubuntu -i ${aws_instance.web.public_ip}, --private-key ${var.privatekey} jenkins.yml"
 # }
}
output "web_ip" {
  value = aws_instance.web.public_ip
}
