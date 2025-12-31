# JSP Servlet Secure Communication Web Application

A secure web application built with Java JSP and Servlets for role-based communication between administrators and officers.

## Features

- **User Authentication**: Secure login with username and password
- **Role-Based Access Control**: Admin and Officer roles with different permissions
- **Message System**: Admins can send messages to all officers
- **Message Viewing**: Officers can view received messages
- **Security Features**:
  - Session management
  - Password hashing (SHA-256)
  - XSS prevention through input sanitization
  - SQL injection prevention using PreparedStatements
- **MySQL Database**: Persistent data storage

## Technology Stack

- **Backend**: Java Servlets, JSP
- **Database**: MySQL
- **Server**: Apache Tomcat
- **Security**: SHA-256 password hashing, HTML escaping

## Project Structure

```
communication-web/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/communication/
│       │       ├── servlet/        # Servlets for request handling
│       │       ├── dao/            # Data Access Objects
│       │       ├── model/          # Entity classes
│       │       ├── util/           # Utility classes
│       │       └── filter/         # Servlet filters
│       ├── webapp/
│       │   ├── WEB-INF/
│       │   │   └── web.xml         # Web application configuration
│       │   ├── css/
│       │   │   └── style.css       # Stylesheet
│       │   └── *.jsp               # JSP pages
│       └── resources/
│           └── database.properties # Database configuration
├── sql/
│   └── schema.sql                  # Database schema
└── README.md
```

## Prerequisites

- Java JDK 8 or higher
- Apache Tomcat 9.0 or higher
- MySQL 5.7 or higher
- MySQL JDBC Driver (mysql-connector-java-8.0.x.jar or higher)

## Setup Instructions

### 1. Database Setup

1. Start MySQL server
2. Execute the SQL script to create the database and tables:
   ```bash
   mysql -u root -p < sql/schema.sql
   ```
   Or manually run the SQL commands in `sql/schema.sql`

### 2. Database Configuration

Edit `src/main/resources/database.properties` with your MySQL credentials:

```properties
db.url=jdbc:mysql://localhost:3306/communication_db?useSSL=false&serverTimezone=UTC
db.username=your_username
db.password=your_password
db.driver=com.mysql.cj.jdbc.Driver
```

### 3. Add MySQL JDBC Driver

1. Download MySQL JDBC Driver from [MySQL Connector/J](https://dev.mysql.com/downloads/connector/j/)
2. Place the JAR file in `WEB-INF/lib/` directory:
   ```
   src/main/webapp/WEB-INF/lib/mysql-connector-java-8.0.xx.jar
   ```

### 4. Build and Deploy

#### Option A: Using Maven (if using Maven project structure)

1. Add Maven dependencies to `pom.xml`:
   ```xml
   <dependencies>
       <dependency>
           <groupId>javax.servlet</groupId>
           <artifactId>javax.servlet-api</artifactId>
           <version>4.0.1</version>
           <scope>provided</scope>
       </dependency>
       <dependency>
           <groupId>javax.servlet.jsp</groupId>
           <artifactId>javax.servlet.jsp-api</artifactId>
           <version>2.3.3</version>
           <scope>provided</scope>
       </dependency>
       <dependency>
           <groupId>mysql</groupId>
           <artifactId>mysql-connector-java</artifactId>
           <version>8.0.33</version>
       </dependency>
   </dependencies>
   ```

2. Build the project:
   ```bash
   mvn clean package
   ```

3. Deploy the WAR file to Tomcat's `webapps` directory

#### Option B: Manual Deployment

1. Compile Java classes:
   ```bash
   javac -cp "path/to/servlet-api.jar:path/to/mysql-connector.jar" src/main/java/com/communication/**/*.java
   ```

2. Copy compiled classes to `WEB-INF/classes/`

3. Copy the entire `webapp` directory to Tomcat's `webapps/communication-web/`

### 5. Start Tomcat

1. Start Apache Tomcat server
2. Access the application at: `http://localhost:8080/communication-web/`

## Default Credentials

The application comes with sample users:

- **Admin**:
  - Username: `admin`
  - Password: `admin123`

- **Officer**:
  - Username: `officer1`
  - Password: `officer123`

**Important**: Change these default passwords in production!

## Usage

### Admin Functions

1. Login with admin credentials
2. View list of all officers
3. Send messages to all officers
4. View sent messages

### Officer Functions

1. Login with officer credentials
2. View received messages
3. Click on messages to read details
4. Unread messages are highlighted

## Security Features

1. **Password Hashing**: All passwords are hashed using SHA-256 before storage
2. **Session Management**: User sessions are managed with 30-minute timeout
3. **XSS Prevention**: All user inputs are sanitized using HTML escaping
4. **SQL Injection Prevention**: All database queries use PreparedStatements
5. **Role-Based Access**: Servlets check user roles before allowing access

## Troubleshooting

### Database Connection Issues

- Verify MySQL server is running
- Check database credentials in `database.properties`
- Ensure database `communication_db` exists
- Verify MySQL JDBC driver is in classpath

### 404 Errors

- Check servlet mappings in `web.xml`
- Verify JSP files are in correct location
- Ensure Tomcat is running and application is deployed

### ClassNotFoundException

- Ensure MySQL JDBC driver is in `WEB-INF/lib/`
- Check that all Java classes are compiled and in `WEB-INF/classes/`

## Development Notes

- The application uses annotation-based servlet mapping (`@WebServlet`)
- For older Tomcat versions, you may need to add servlet mappings in `web.xml`
- Session timeout is set to 30 minutes (configurable in `web.xml`)
- All user inputs are sanitized to prevent XSS attacks

## License

This project is provided as-is for educational purposes.

