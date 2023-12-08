/*Step 3: For internet access from public subnet you need internet gateway*/
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "ig"
  }
}