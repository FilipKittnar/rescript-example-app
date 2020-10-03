--liquibase formatted sql
				
--changeset kittnarf:person-create-01
create table person (  
    id uuid primary key,
    name varchar(255) not null,
    age smallint null,
    active boolean not null,
    created timestamp with time zone default current_timestamp not null,
    last_modified timestamp null
);  
--rollback drop table person; 

--changeset kittnarf:person-insert-01
insert into person
(id, name, age, active)
values
('cfba3b8e-4fe2-4436-ac9b-0d1d507624e9', 'John Doe', 37, true);
--rollback delete from person where id = 'cfba3b8e-4fe2-4436-ac9b-0d1d507624e9'; 

--changeset kittnarf:person-insert-02
insert into person
(id, name, age, active)
values
('5274091f-7da6-4876-a947-19bf829a7825', 'Francis Blake', 24, false);
--rollback delete from person where id = '5274091f-7da6-4876-a947-19bf829a7825'; 

--changeset kittnarf:person-insert-03
insert into person
(id, name, age, active)
values
('acac2f61-d7b6-4e52-81c0-5c71663fbc99', 'Lucy Liu', null, true);
--rollback delete from person where id = 'acac2f61-d7b6-4e52-81c0-5c71663fbc99'; 
