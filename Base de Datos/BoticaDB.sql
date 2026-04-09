-- Crear base de datos
CREATE DATABASE BoticaDB;
GO

USE BoticaDB;
GO

-- Habilitar claves foráneas
EXEC sp_executesql N'ALTER DATABASE [BoticaDB] SET COMPATIBILITY_LEVEL = 150';

-- Tabla Categorías de productos
CREATE TABLE Categorias (
    CategoriaID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Descripcion VARCHAR(200),
    FechaCreacion DATETIME DEFAULT GETDATE()
);

-- Tabla Proveedores
CREATE TABLE Proveedores (
    ProveedorID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Contacto VARCHAR(100),
    Telefono VARCHAR(20),
    Email VARCHAR(100),
    Direccion VARCHAR(200),
    FechaRegistro DATETIME DEFAULT GETDATE()
);

-- Tabla Productos (Medicamentos)
CREATE TABLE Productos (
    ProductoID INT IDENTITY(1,1) PRIMARY KEY,
    CodigoProducto VARCHAR(20) UNIQUE NOT NULL,
    NombreProducto VARCHAR(150) NOT NULL,
    CategoriaID INT,
    ProveedorID INT,
    PrecioCompra DECIMAL(10,2) NOT NULL,
    PrecioVenta DECIMAL(10,2) NOT NULL,
    StockActual INT DEFAULT 0,
    StockMinimo INT DEFAULT 10,
    UnidadMedida VARCHAR(20) DEFAULT 'UNIDAD',
    FechaVencimiento DATE,
    Estado VARCHAR(20) DEFAULT 'ACTIVO', -- ACTIVO, INACTIVO, VENCIDO
    FechaCreacion DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CategoriaID) REFERENCES Categorias(CategoriaID),
    FOREIGN KEY (ProveedorID) REFERENCES Proveedores(ProveedorID)
);

-- Tabla Clientes
CREATE TABLE Clientes (
    ClienteID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100) NOT NULL,
    DNI VARCHAR(20) UNIQUE,
    Telefono VARCHAR(20),
    Email VARCHAR(100),
    Direccion VARCHAR(200),
    FechaNacimiento DATE,
    FechaRegistro DATETIME DEFAULT GETDATE()
);

-- Tabla Ventas (Encabezado)
CREATE TABLE Ventas (
    VentaID INT IDENTITY(1,1) PRIMARY KEY,
    ClienteID INT NULL,
    FechaVenta DATETIME DEFAULT GETDATE(),
    TotalVenta DECIMAL(12,2) NOT NULL,
    FormaPago VARCHAR(50) DEFAULT 'EFECTIVO', -- EFECTIVO, TARJETA, TRANSFERENCIA
    Estado VARCHAR(20) DEFAULT 'COMPLETADA', -- COMPLETADA, ANULADA, PENDIENTE
    Observaciones VARCHAR(500),
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID)
);

-- Tabla Detalle de Ventas
CREATE TABLE DetalleVentas (
    DetalleID INT IDENTITY(1,1) PRIMARY KEY,
    VentaID INT NOT NULL,
    ProductoID INT NOT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    Subtotal DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (VentaID) REFERENCES Ventas(VentaID),
    FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID)
);

-- Índices para mejor rendimiento
CREATE INDEX IX_Productos_Codigo ON Productos(CodigoProducto);
CREATE INDEX IX_Productos_Stock ON Productos(StockActual);
CREATE INDEX IX_Ventas_Fecha ON Ventas(FechaVenta);
CREATE INDEX IX_DetalleVentas_VentaID ON DetalleVentas(VentaID);

-- DATOS DE PRUEBA
INSERT INTO Categorias (Nombre, Descripcion) VALUES 
('Analgésicos', 'Medicamentos para dolor'),
('Antibióticos', 'Medicamentos antibacterianos'),
('Antihipertensivos', 'Control de presión arterial'),
('Vitaminas', 'Suplementos vitamínicos'),
('Gastrointestinales', 'Para problemas digestivos');

INSERT INTO Proveedores (Nombre, Contacto, Telefono, Email) VALUES 
('Laboratorios Pfizer', 'Juan Pérez', '555-0101', 'pfizer@lab.com'),
('Roche Argentina', 'María Gómez', '555-0102', 'roche@lab.com'),
('GSK Farmacéutica', 'Carlos López', '555-0103', 'gsk@lab.com');

INSERT INTO Productos (CodigoProducto, NombreProducto, CategoriaID, ProveedorID, PrecioCompra, PrecioVenta, StockActual, StockMinimo, FechaVencimiento) VALUES 
('PAR001', 'Paracetamol 500mg', 1, 1, 2.50, 4.00, 150, 20, '2027-06-30'),
('IBA001', 'Ibuprofeno 400mg', 1, 1, 3.00, 5.50, 80, 15, '2027-05-15'),
('AMI001', 'Amoxicilina 500mg', 2, 2, 4.20, 7.00, 45, 10, '2026-12-31'),
('ENAL001', 'Enalapril 10mg', 3, 3, 3.80, 6.50, 120, 25, '2027-08-20'),
('VIT001', 'Vitamina C 1000mg', 4, 1, 1.50, 3.00, 200, 30, '2027-03-10');

INSERT INTO Clientes (Nombre, Apellido, DNI, Telefono, Email) VALUES 
('Juan Carlos', 'Rodríguez', '30123456', '341-5550123', 'juan@email.com'),
('María Elena', 'Fernández', '32123457', '341-5550456', 'maria@email.com');

