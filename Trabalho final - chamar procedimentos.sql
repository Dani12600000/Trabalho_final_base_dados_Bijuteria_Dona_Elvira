USE DB_Bijuteria_Dona_Elvira;

call ExecutarInsercaoRegistosMultiplosPessoas(1000);
call ExecutarInsercaoRegistosMultiplosClientes(500);
-- call ApagarRegistosRepetidosClientes(); No mas necessario :D
call ExecutarInsercaoRegistosMultiplosFuncionarios(50);
