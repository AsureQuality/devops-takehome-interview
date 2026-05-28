Task 1 — Build a reusable VPC module

* Getting-Started, step 2 uses wrong path for source file ('.env.example', NOT 'starter/.env.example')

* For aws_route_table I had to wrap the route in a dynamic block to implement the "when enabled" condition.

* Added aws_internet_gateway.main to the depends_on condition for the aws_nat_gateway as the subnet only has internet connectivity after the internet gateway is attached and the route table association is in place.