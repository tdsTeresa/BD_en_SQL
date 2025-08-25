

---CREACI�N DE BASE DE DATOS
CREATE DATABASE INFORDATA

---CREACI�N DE TABLAS E IMPORTACI�N DE DATOS
--Tabla Productos

CREATE TABLE Productos (CodigoProducto int not null identity,
						NIFProveedor nvarchar (13) not null,	
						Modelo	varchar (255),
						Descripcion	varchar(255),
						MemoriaPrincipalGHz varchar (50),	
						Velocidadppm varchar(50),
						CapacidadTB varchar(50),
						ResolucionMaximaK varchar(50),	
						Precio decimal (10,2),
						foreign key (NIFProveedor) references Proveedores(NIFProveedor),
						primary key(CodigoProducto))

--Tabla Proveedores

CREATE TABLE Proveedores (NIFProveedor nvarchar(13) not null,
							Nombre varchar(255), Direccion varchar(255),
							Primary key(NIFProveedor))



--Tabla Movimientos
CREATE TABLE Movimientos (IdMovimiento INT NOT NULL identity,
							CodigoProducto	int not null,
							DNICliente	nvarchar(12) not null,
							Concepto varchar(50),
							CONSTRAINT chk_Concepto
							CHECK (Concepto IN ('Venta', 'Alquiler', 'Soporte')),
							Fecha date,
							IdSoporte int,
							foreign key(CodigoProducto) references Productos(CodigoProducto),
							foreign key (DNICliente) references Clientes(DNICliente),
							foreign key(IdSoporte) references SoporteTecnico(IdSoporte),
							primary key(IdMovimiento))

							Alter table Movimientos add HorasAlquiler int
							Alter table Movimientos add Cantidad int
							update Movimientos set Cantidad=1



--Tabla Clientes
CREATE TABLE Clientes (DNICliente nvarchar(12) not null,
						Nombre varchar(50),
						ApellidoPaterno varchar(50),
						ApellidoMaterno varchar(50),
						Telefono nvarchar(12),
						Domicilio varchar(255),
						primary key(DNICliente)) 
				
						Alter table Clientes add Sexo varchar(10)



--Tabla Alquiler
CREATE TABLE Alquiler (CodigoProducto int not null, PrecioHora decimal (10,2), 
						foreign key (CodigoProducto) references Productos (CodigoProducto))



--Tabla Soporte T�cnico
CREATE TABLE SoporteTecnico (IdSoporte int not null identity,
								IdEmpresa int not null, 
								CodigoProducto int not null,
								Descripcion varchar(255),
								Precio decimal(10,2),
								Foreign key (IdEmpresa) references Fabricante(IdEmpresa),  
								foreign key (CodigoProducto) references Productos(CodigoProducto),
								primary key(IdSoporte))




--Tabla Fabricante
CREATE TABLE Fabricante (IdEmpresa int not null identity,
							Nombre varchar(50),
							PaisOrigen varchar(50),
							primary key (IdEmpresa))



--Tabla Alta tecnolog�a
CREATE TABLE AltaTecnologia (CodigoProducto int not null,
							IdEmpresa int not null,
							FechaFabricacion Date,
							foreign key (IdEmpresa) references Fabricante (IdEmpresa),
							primary key(CodigoProducto))



---FINALIZA CREACI�N DE TABLAS E IMPORTACI�N DE DATOS

---CONSULTAS A LA BASE DE DATOS

--Productos que proporciona cada proveedor
Select pr.NIFProveedor, pr.Nombre, p.Descripcion from Productos p
		inner join Proveedores pr on p.NIFProveedor= pr.NIFProveedor 
		Order by pr.Nombre, p.Descripcion


----Precio de alquiler por hora s�lo para monitores y discos duros
select p.Modelo,
		LEFT(p.Descripcion, 20) as Descripci�n,
		ISNULL(p.ResolucionMaximaK,'No Disponible') as Resoluci�n,
		ISNULL(p.CapacidadTB, 'No Disponible') as Capacidad, 
		a.PrecioHora from Productos p 
		inner join Alquiler a on a.CodigoProducto=p.CodigoProducto where p.Descripcion like '%Monitor%' or p.Descripcion like'%Disco Duro%'


----Algunos productos pertenecen a la categor�a de Alta tecnolog�a
Select p.Descripcion, f.Nombre as Fabricante, f.PaisOrigen,
		ISNULL(CONVERT(varchar, a.FechaFabricacion), 'No Disponible') as FechaFabricaci�n
		from AltaTecnologia a 
		inner join Productos p on  p.CodigoProducto= a.CodigoProducto
		inner join Fabricante f on f.IdEmpresa=a.IdEmpresa



--Clientes que han adquirido impresoras

Select c.DNICliente, 
		concat(c.Nombre, ' ', c.ApellidoPaterno, ' ',  c.ApellidoMaterno)as Nombre, 
		c.Telefono, c.Domicilio, m.Fecha, p.Descripcion, 
		(p.Precio * m.Cantidad) as TotalVenta,
		ISNULL(convert(varchar, (s.Precio * m.Cantidad)), 'No') as TotalServicioT�cnico
		from Movimientos m 
		left join Productos p on p.CodigoProducto=m.CodigoProducto
		left join Clientes c on c.DNICliente= m.DNICliente
		left join SoporteTecnico s on s.IdSoporte=m.IdSoporte
		where p.Descripcion like '%Impresora%' and m.Concepto in ('Soporte', 'Venta') 
		order by m.Fecha


 -- S�lo se puede ofrecer servicio t�cnico a clientes que han adquirido el producto.
 GO
	CREATE OR ALTER PROC RegistrarSoporte
    @CodigoProducto int, 
    @DNICliente nvarchar(12),
	@Concepto varchar(50),
    @Fecha Date,
	@IdSoporte int, 
	@HorasAlquiler int,
	@Cantidad int
	AS 
	BEGIN
    IF @Concepto IN ('Venta') --Registrar venta en la tabla 'Movimientos'
    BEGIN
        INSERT INTO Movimientos (CodigoProducto,DNICliente,Concepto,Fecha, IdSoporte, HorasAlquiler, Cantidad)
			VALUES (@CodigoProducto, @DNICliente, @Concepto, getdate(), NULL, NULL, @Cantidad)
		END

		--Verificar si el servicio de Soporte T�cnico existe para el producto solicitado
    ELSE IF @Concepto = 'Soporte' and @idSoporte in (Select IdSoporte from SoporteTecnico) and @CodigoProducto in (Select CodigoProducto from SoporteTecnico)
    BEGIN  
		--Verificar si el producto ha sido adquirido antes por el mismo cliente
      IF EXISTS (SELECT IdMovimiento FROM Movimientos
					WHERE DNICliente = @DNICliente and  
							CodigoProducto=@CodigoProducto 
										and Concepto='Venta')
        BEGIN  --Registrar servicio de Soporte T�cnico en la tabla 'Movimientos'
           INSERT INTO Movimientos (CodigoProducto,DNICliente,Concepto,Fecha, IdSoporte, HorasAlquiler, Cantidad)
        VALUES (@CodigoProducto, @DNICliente, @Concepto, getdate(), @IdSoporte, NULL, @Cantidad)
            END
			--Verificar si el servicio de Alquiler existe para el producto solicitado
			ELSE IF @Concepto = 'Alquiler' and @CodigoProducto in (Select CodigoProducto from Alquiler)
    BEGIN  
			--Registrar serivicio de Alquiler en la tabla 'Movimientos'
           INSERT INTO Movimientos (CodigoProducto,DNICliente,Concepto,Fecha, IdSoporte, HorasAlquiler, Cantidad)
        VALUES (@CodigoProducto, @DNICliente, @Concepto, getdate(), NULL, @HorasAlquiler, NULL)
            END 
			
			END
		ELSE BEGIN
           
            PRINT('SERVICIO INEXISTENTE')
		END 
		END 

exec RegistrarSoporte 279, 'RRTBH235HH', 'Soporte', '2025-07-15', 12, null, 1 
