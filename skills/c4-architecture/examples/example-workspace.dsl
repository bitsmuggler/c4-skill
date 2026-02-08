workspace "Online Bookstore" "An example C4 model for an online bookstore system." {

    model {
        // People
        customer = person "Customer" "A customer who browses and purchases books."
        admin = person "Admin" "An administrator who manages inventory and orders."

        // Primary system
        bookstore = softwareSystem "Online Bookstore" "Allows customers to browse, search, and purchase books online." {

            webApp = container "Web Application" "Serves the bookstore frontend to customers." "React / Next.js" "WebBrowser"
            adminPortal = container "Admin Portal" "Management interface for inventory and orders." "React"

            apiGateway = container "API Gateway" "Routes and authenticates API requests." "Kong"

            catalogService = container "Catalog Service" "Manages book catalog, search, and recommendations." "Node.js / Express"
            orderService = container "Order Service" "Handles order placement and tracking." "Java / Spring Boot"
            userService = container "User Service" "Manages user accounts and authentication." "Node.js / Express"

            catalogDb = container "Catalog Database" "Stores book catalog data." "PostgreSQL" "Database"
            orderDb = container "Order Database" "Stores orders and transactions." "PostgreSQL" "Database"
            userDb = container "User Database" "Stores user accounts and credentials." "PostgreSQL" "Database"

            messageQueue = container "Message Queue" "Handles async communication between services." "RabbitMQ" "Queue"
        }

        // External systems
        paymentGateway = softwareSystem "Payment Gateway" "Processes credit card payments." "External"
        emailService = softwareSystem "Email Service" "Sends transactional emails." "External"
        searchEngine = softwareSystem "Search Engine" "Provides full-text search capabilities." "External"

        // Relationships: People -> Systems
        customer -> bookstore "Browses and purchases books using"
        admin -> bookstore "Manages inventory and orders using"

        // Relationships: People -> Containers
        customer -> webApp "Browses books and places orders" "HTTPS"
        admin -> adminPortal "Manages catalog and processes orders" "HTTPS"

        // Relationships: Containers -> Containers
        webApp -> apiGateway "Makes API calls to" "REST/JSON"
        adminPortal -> apiGateway "Makes API calls to" "REST/JSON"

        apiGateway -> catalogService "Routes catalog requests to" "REST/JSON"
        apiGateway -> orderService "Routes order requests to" "REST/JSON"
        apiGateway -> userService "Routes auth requests to" "REST/JSON"

        catalogService -> catalogDb "Reads from and writes to" "JDBC"
        orderService -> orderDb "Reads from and writes to" "JDBC"
        userService -> userDb "Reads from and writes to" "JDBC"

        catalogService -> searchEngine "Indexes and queries" "REST/JSON"
        orderService -> messageQueue "Publishes order events to" "AMQP"
        catalogService -> messageQueue "Consumes inventory updates from" "AMQP"

        // Relationships: System -> External
        orderService -> paymentGateway "Processes payments via" "REST/JSON"
        orderService -> emailService "Sends order confirmations via" "SMTP"
        userService -> emailService "Sends verification emails via" "SMTP"

        // Deployment
        deploymentEnvironment "Production" {
            deploymentNode "AWS" "Amazon Web Services" "Cloud" {
                deploymentNode "ECS Cluster" "Container orchestration" "AWS ECS" {
                    containerInstance webApp
                    containerInstance adminPortal
                    containerInstance apiGateway
                    containerInstance catalogService
                    containerInstance orderService
                    containerInstance userService
                }
                deploymentNode "RDS" "Managed databases" "AWS RDS" {
                    containerInstance catalogDb
                    containerInstance orderDb
                    containerInstance userDb
                }
                deploymentNode "Amazon MQ" "Managed message broker" "AWS Amazon MQ" {
                    containerInstance messageQueue
                }
            }
        }
    }

    views {
        // Level 1: System Context
        systemContext bookstore "SystemContext" "System Context diagram for the Online Bookstore" {
            include *
            autoLayout
        }

        // Level 2: Container
        container bookstore "Containers" "Container diagram showing the internal structure" {
            include *
            autoLayout
        }

        // Level 3: Deployment
        deployment bookstore "Production" "Deployment" "Production deployment on AWS" {
            include *
            autoLayout
        }

        // Dynamic: Order flow
        dynamic bookstore "OrderFlow" "Shows the order placement flow" {
            customer -> webApp "Places order"
            webApp -> apiGateway "POST /orders"
            apiGateway -> orderService "Forward order request"
            orderService -> orderDb "Persist order"
            orderService -> paymentGateway "Process payment"
            orderService -> messageQueue "Publish OrderPlaced event"
            orderService -> emailService "Send confirmation email"
            autoLayout
        }

        styles {
            element "Person" {
                shape Person
                background #08427B
                color #ffffff
            }
            element "Software System" {
                background #1168BD
                color #ffffff
            }
            element "Container" {
                background #438DD5
                color #ffffff
            }
            element "Database" {
                shape Cylinder
            }
            element "Queue" {
                shape Pipe
            }
            element "WebBrowser" {
                shape WebBrowser
            }
            element "External" {
                background #999999
                color #ffffff
            }
        }
    }

}
