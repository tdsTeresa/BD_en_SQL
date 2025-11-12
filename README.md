
<h2>📚 Descripción general:</h2>
<br>
En esta actividad realicé la definición de una base de datos relacional a partir de un enunciado de ejemplo extraído de Slideshare. El archivo .sql contiene la estructura de la BD, creación de tablas, relaciones entre tablas y algunas consultas relevantes para una tienda de cómputo ficticia INFORDATA. <br><br>
▫️Los datos de proveedores, clientes, números de teléfono, IDs, NIFs, domicilios y fechas han sido material creado como ejemplo y para fines educativos durante esta actividad.<br><br>
▫️Algunos datos, como códigos, descripciones de producto y precios fueron extraídos de  <a href= "https://www.pcel.com/index.php?route=common/home">PCEL, Súper tienda de cómputo</a>



<br><br>
<h2>⚙️Tecnologías: </h2>
<br>
    • SQL Server <br>
    • Wondershare EdrawMax <br>
<br>

<h2>🖇️ Fuente: </h2><br>
https://es.slideshare.net/slideshow/enunciados-de-casos-para-bases-de-datos/12547875 (Pag. 8).

<br>
<h2>🧩 Tablas creadas:</h2
<br>
Productos (Código, NIF de Proveedor, Modelo, Descripción, Memoria principal, Velocidad, Capacidad, Resolución máxima, Precio).<br>
Proveedores (NIF de Proveedor, Nombre, Dirección).<br>
Movimientos (ID, Código de producto, DNI de Cliente, Concepto, Fecha, ID de Soporte).<br>
Clientes (DNI de Cliente, Nombre, Apellido Paterno, Apellido Materno, Teléfono, Domicilio).<br>
Alquiler (Código de Producto, Precio por Hora).<br>
Soporte técnico (ID de Soporte, ID de Empresa, Código de Producto, Descripción, Precio).<br>
Fabricante (ID de Empresa, Nombre, País de Origen).<br>
Alta Tecnología (Código de Producto, ID de Empresa, Fecha de Fabricación).<br>
<br>
<br>
<h2>📊 Actividades: </h2>
<br>
  • Definición de llaves primarias con atributos Identity. <br>
  • Definición de llaves foráneas para facilitar consultas con filtros en la base de datos. <br>
  • En campos como DNICliente se define el tipo de dato como nvarchar (12) para delimitar el número de caracteres que puede ser registrado. <br>
  • Se permiten registros nulos en varios campos de la tabla Movimientos, ya que, conforme al enunciado, cada producto tiene datos de interés distintos. <br>
  • En la tabla Movimientos se registran todas las operaciones, en el campo Concepto se aplica Constraint y Check para delimitar las opciones a Ventas, Alquiler y Soporte. <br>
  • Realización de un procedimiento almacenado que niega el Soporte Técnico si un producto no ha sido vendido al mismo cliente anteriormente.<br>
  
<br>
<h2>Diagrama Entidad - Relación</h2>
<br>
<img width="700" height="761" alt="image" src="https://github.com/user-attachments/assets/65b33d30-7f82-4a6d-8b73-973f3a09e976" />
<br><br>
<h2>Consultas realizadas: </h2>
<br>
▫️Productos por Proveedor<br><br>

![Productos por Proveedor](images/proveedores.png)
<br><br>
▫️Precio de alquiler por hora (sólo para monitores y discos duros)<br><br>
![Precio de Alquiler](images/alquiler.png)
<br><br>
▫️Productos de 'Alta Tecnología'<br><br>
![Alta Tecnologia](images/alta_tecnologia.png)
<br><br>
▫️Detalle de clientes que han adquirido impresoras <br><br>
![Clientes que han adquirido impresoras](images/impresoras.png)<br><br>
▫️Restricción de Servicio técnico a productos que no han sido adquiridos por el cliente<br><br>
![Servicio Técnico](images/servicio_tecnico.png)
<br><br>
<h2>🔶 Conclusión:</h2>
<br>
En esta actividad se propuso una estructura simple para el registro y la organización de los productos de un negocio, ideal para su aplicación en pequeñas y grandes empresas.
<br>



