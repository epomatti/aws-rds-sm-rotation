output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets_ids" {
  value = [aws_subnet.public1.id, aws_subnet.public2.id]
}
