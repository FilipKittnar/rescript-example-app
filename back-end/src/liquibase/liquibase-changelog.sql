--liquibase formatted sql
				
--changeset kittnarf:todo-create-01
CREATE TABLE todo(
   id uuid primary key not null,
   description text not null,
   completed boolean default false
)
--rollback drop table todo; 

--changeset kittnarf:todo-insert-01
insert into todo
(id, description)
values
('cfba3b8e-4fe2-4436-ac9b-0d1d507624e9', 'Implement ReScript BE');
--rollback delete from todo where id = 'cfba3b8e-4fe2-4436-ac9b-0d1d507624e9'; 

--changeset kittnarf:todo-insert-02
insert into todo
(id, description)
values
('5274091f-7da6-4876-a947-19bf829a7825', 'Implement ReScript FE');
--rollback delete from todo where id = '5274091f-7da6-4876-a947-19bf829a7825'; 

--changeset kittnarf:todo-insert-03
insert into todo
(id, description, completed)
values
('acac2f61-d7b6-4e52-81c0-5c71663fbc99', 'Create database', true);
--rollback delete from todo where id = 'acac2f61-d7b6-4e52-81c0-5c71663fbc99'; 
