{
    Realizar un programa para una tienda de celulares, que presente un menú con
    opciones para:
        a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
        ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
        correspondientes a los celulares, deben contener: código de celular, el nombre,
        descripcion, marca, precio, stock mínimo y el stock disponible.
        b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
        stock mínimo.
        c. Listar en pantalla los celulares del archivo cuya descripción contenga una
        cadena de caracteres proporcionada por el usuario.
        d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
        “celulares.txt” con todos los celulares del mismo.
        NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario
        una única vez.
        NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en
        tres líneas consecutivas: en la primera se especifica: código de celular, el precio y
        marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
        nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo
        “celulares.txt”.
}

program ejercicio5;
const
    valor_corte = -1;
type

    celular = record
        cod: integer;
        nombre: string[25];
        descripcion: string[25];
        marca: string[25];
        precio: real;
        stock_minimo: integer;
        stock_disponible: integer;
    end;

    archivo_maestro = file of celular;

    procedure leer_registro(var reg_m: celular);
    begin
        write('Ingrese codigo de celular: ');
        readln(reg_m.cod);
        if (reg_m.cod <> valor_corte) then begin
            write('Ingrese nombre de celular: ');
            readln(reg_m.nombre);
            write('Ingrese descripción de celular: ');
            readln(reg_m.descripcion);
            write('Ingrese marca de celular: ');
            readln(reg_m.marca);
            write('Ingrese precio de celular: ');
            readln(reg_m.precio);
            write('Ingrese stock minimo de celular: ');
            readln(reg_m.stock_minimo);
            write('Ingrese stock disponible de celular: ');
            readln(reg_m.stock_disponible);
        end;
    end;

    procedure imprimir_registro(var reg_m: celular);
    begin
        write(#10,'Cod: ', reg_m.cod, #10, 'Nombre: ', reg_m.nombre, #10, 'Descripción: ', reg_m.descripcion, #10, 'Marca: ', reg_m.marca, #10, 'Precio: $', reg_m.precio:2:2, #10, 'Stock minimo: ', reg_m.stock_minimo, #10,'Stock disponible: ', reg_m.stock_disponible, #10);
    end;

    procedure listar_stock(var archivo: archivo_maestro);
    var
        reg_m: celular;
    begin
        reset(archivo);
        while not eof(archivo) do begin
            read(archivo,reg_m);
            if(reg_m.stock_disponible < reg_m.stock_minimo) then
                imprimir_registro(reg_m);
        end;
        close(archivo);
    end;

    procedure listar_nombre(var archivo: archivo_maestro);
    var
        reg_m: celular;
        cadena: string[25];
    begin
        write('Ingrese descripción del celular a buscar: ');
        readln(cadena);
        reset(archivo);
        while not eof(archivo) do begin
            read(archivo,reg_m);
            if(pos(cadena,reg_m.descripcion) > 0) then
                imprimir_registro(reg_m);
        end;
        close(archivo);
    end;

    procedure exportar_todos_celulares(var archivo: archivo_maestro);
    var
        reg_m: celular;
        archivo_texto: Text;
    begin
        Assign(archivo_texto,'“celulares.txt');
        rewrite(archivo_texto);
        reset(archivo);
        while not eof(archivo) do begin
            read(archivo,reg_m);
            write(archivo_texto,'Codigo: ', reg_m.cod, ', Precio: $', reg_m.precio:2:2, ', Marca: ', reg_m.marca, #10, 'Stock disponible: ', reg_m.stock_disponible, ', Stock minimo: ', reg_m.stock_minimo,', Descripcion: ', reg_m.descripcion, #10, 'Nombre: ', reg_m.nombre, #10);
        end;
        close(archivo);
        close(archivo_texto);
    end;


    procedure imprimir_opciones2();
    begin
        writeln('1.Listar celulares que tengan un stock menor al stock mínimo.');
        writeln('2.Listar en pantalla los celulares del archivo cuya descripción contenga una cadena de caracteres proporcionada por el usuario.');
        writeln('3.Exportar el archivo creado en el inciso a) a un archivo de texto denominado “celulares.txt” con todos los celulares del mismo.');
        writeln('4.Volver atras');
        writeln('5.Salir');
    end;

    procedure menu2(var archivo: archivo_maestro);
    var
        seleccion : string;
    begin
        imprimir_opciones2();
        write('Ingrese una opcion: ');
        readln(seleccion);
        case seleccion of
            '1': listar_stock(archivo);
            '2': listar_nombre(archivo);
            '3': exportar_todos_celulares(archivo);
            '4': exit;
            '5': halt;
            else begin
                write('Ingrese una opcion valida');
                menu2(archivo);
            end;
        end;
        menu2(archivo);
    end;


    procedure imprimir_opciones();
    begin
        writeln('1.Crear archivo de celulares');
        writeln('2.Abrir archivo de celulares');
        writeln('3.Salir');
    end;


    procedure crear_archivo(var archivo: archivo_maestro);
    var
        reg_m: celular;
    begin
        Rewrite(archivo);
        leer_registro(reg_m);
        while(reg_m.cod <> valor_corte) do begin
            write(archivo,reg_m);
            leer_registro(reg_m);
        end;
        close(archivo);
    end;

    procedure menu(var archivo: archivo_maestro);
    var
        seleccion : string;
    begin
        imprimir_opciones();
        write('Ingrese una opcion: ');
        readln(seleccion);
        case seleccion of
            '1': crear_archivo(archivo);
            '2': menu2(archivo);
            '3': halt;
            else begin
                write('Ingrese una opcion valida');
                menu(archivo);
            end;
        end;
        menu(archivo);
    end;

var
    archivo_m: archivo_maestro;
    nombre_archivo: string[25];
begin
    write('Ingrese nombre del archivo con el que va a trabjar: ');
    readln(nombre_archivo);
    Assign(archivo_m,nombre_archivo);
    menu(archivo_m);
    close(archivo_m);
end.