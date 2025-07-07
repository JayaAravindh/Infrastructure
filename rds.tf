resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "ror-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "ror-db-subnet-group"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "ror-rds-sg"
  description = "Allow Postgres access from ECS"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ror-rds-sg"
  }
}

resource "aws_db_instance" "postgres" {
  identifier              = "ror-postgres"
  engine                  = "postgres"
  # engine_version        = "DO NOT SPECIFY" ✅
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = "rorappdb"
  username                = var.db_username
  password                = var.db_password
  skip_final_snapshot     = true
  publicly_accessible     = false
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  multi_az                = false

  tags = {
    Name = "ror-postgres-db"
  }
}

