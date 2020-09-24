const liquibase = require('liquibase');

liquibase({
    changeLogFile: 'liquibase/liquibase-changelog.sql',
    driver: 'org.postgresql.Driver',
    classpath: '../database/postgresql-42.2.16.jar',
    url: 'jdbc:postgresql://localhost:5432/postgres',
    username: 'postgres',
    password: 'postgres'
})
    .run('update');