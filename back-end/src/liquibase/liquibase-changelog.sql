--liquibase formatted sql
				
--changeset kittnarf:user-create-01
create table user (  
    id uuid primary key,
    name varchar(255) not null,
    age smallint null,
    active boolean not null,
    created timestamp not null with time zone default current_timestamp,
    last_modified timestamp null
);  
--rollback drop table user; 

--changeset kittnarf:user-insert-01
insert into user
(id, name, age, active)
values
('cfba3b8e-4fe2-4436-ac9b-0d1d507624e9', 'John Doe', 37, true);
--rollback delete from user where id = 'cfba3b8e-4fe2-4436-ac9b-0d1d507624e9'; 

--changeset kittnarf:user-insert-02
insert into user
(id, name, age, active)
values
('5274091f-7da6-4876-a947-19bf829a7825', 'Francis Blake', 24, false);
--rollback delete from user where id = '5274091f-7da6-4876-a947-19bf829a7825'; 

--changeset kittnarf:user-insert-03
insert into user
(id, name, age, active)
values
('acac2f61-d7b6-4e52-81c0-5c71663fbc99', 'Lucy Liu', null, true);
--rollback delete from user where id = 'acac2f61-d7b6-4e52-81c0-5c71663fbc99'; 
