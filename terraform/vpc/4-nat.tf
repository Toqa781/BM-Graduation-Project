resource "aws_eip" "eip" {
  count = length(var.public_subnet_cidrs)
  domain ="vpc"
}


resource "aws_nat_gateway" "nat" {
    count=length(var.public_subnet_cidrs)
    allocation_id = aws_eip.eip[count.index].id
    subnet_id = aws_subnet.public_subnets[count.index].id

    tags={
        Name="${var.cluster_name}-nat-${count.index+1}"
    
    }
    depends_on = [aws_internet_gateway.igw]
}