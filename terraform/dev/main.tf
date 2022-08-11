terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket         = "rkepler-k8-multi-docker"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    profile        = "rkepler"
    dynamodb_table = "rkepler-k8-multi-docker-locks"
    encrypt        = true
  }
}

provider "aws" {
  profile = "rkepler"
  region  = "us-east-1"
}

resource "aws_security_group" "multi-docker" {
  name = var.multi-docker-sg-name

  ingress {
    from_port   = var.multi-docker-sg-port-from
    to_port     = var.multi-docker-sg-port-to
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/*
Create the redis instance required by the course
*/

resource "aws_elasticache_cluster" "multi-docker-redis" {
  cluster_id         = "no-cluster-baby"
  engine             = "redis"
  engine_version     = "6.2"
  node_type          = "cache.t3.micro"
  num_cache_nodes    = 1
  port               = 6379
  security_group_ids = [aws_security_group.multi-docker.id]
  apply_immediately  = true
}

/*
Create the postgres instance required by the course
*/
resource "aws_db_instance" "multi-docker-postgres" {
  identifier             = var.db_instance_identifier
  instance_class         = "db.t3.micro"
  allocated_storage      = 10
  engine                 = "postgres"
  engine_version         = "14.2"
  multi_az               = false
  username               = var.master_user_name
  password               = var.master_password
  db_name                = var.initial_db_name
  publicly_accessible    = false
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.multi-docker.id]
}

resource "aws_elastic_beanstalk_application" "multi-docker-app" {
  name        = "multi-docker"
  description = "Multi Docker application"
}

resource "aws_elastic_beanstalk_environment" "multi-docker-env" {
  name                = "Multidocker-env"
  application         = aws_elastic_beanstalk_application.multi-docker-app.name
  # see https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html#platforms-supported.docker
  # for available options on "solution stack name":
  solution_stack_name = "64bit Amazon Linux 2 v3.4.17 running Docker"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = "${aws_security_group.multi-docker.name}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "REDIS_HOST"
    value     = aws_elasticache_cluster.multi-docker-redis.cache_nodes.0.address
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "REDIS_PORT"
    value     = aws_elasticache_cluster.multi-docker-redis.port
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PGUSER"
    value     = "postgres"
  }


  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PGPASSWORD"
    value     = "postgrespassword"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PGHOST"
    value     = aws_db_instance.multi-docker-postgres.address
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PGPORT"
    value     = aws_db_instance.multi-docker-postgres.port
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PGDATABASE"
    value     = aws_db_instance.multi-docker-postgres.db_name
  }

}



