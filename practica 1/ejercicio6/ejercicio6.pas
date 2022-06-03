{
    Agregar al menú del programa del ejercicio 5, opciones para:
        a. Añadir uno o más celulares al final del archivo con sus datos ingresados por
        teclado.
        b. Modificar el stock de un celular dado.
        c. Exportar el contenido del archivo binario a un archivo de texto denominado:
        ”SinStock.txt”, con aquellos celulares que tengan stock 0.
        NOTA: Las búsquedas deben realizarse por nombre de celular
}

program ejercicio6;
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


    procedure aniadir_celular(var archivo: archivo_maestro);
    var
        reg_m: celular;
    begin
        reset(archivo);
        seek(archivo,filesize(archivo));
        leer_registro(reg_m);
        while (reg_m.cod <> valor_corte) do begin
            write(archivo,reg_m);
            leer_registro(reg_m);
        end;
        close(archivo);
    end;

    procedure modificar_stock(var archivo: archivo_maestro);
    var
        reg_m: celular;
        nombre: string[25];
        stock_nuevo: integer;
        ok: boolean;
    begin
        reset(archivo);
        write('Ingrese nombre de celular a modificar: ', #10, 'Para dejar de modificar ingrese fin: ');
        readln(nombre);
        ok:=False;
        while(nombre <> 'fin') do begin
            while not eof(archivo) do begin
                read(archivo,reg_m);
                if(nombre = reg_m.nombre) then begin;
                    write('Celular encontrado, ingrese stock a modificar: ');
                    readln(stock_nuevo);
                    reg_m.stock_disponible := stock_nuevo;
                    seek(archivo,filepos(archivo)-1);
                    write(archivo,reg_m);
                    ok:= True;
                end;
            end;
            if not (ok) then
                write('El celular con nombre: ', nombre, ' no se encontro.');
            write('Ingrese nombre de celular a modificar: ', #10, 'Para dejar de modificar ingrese fin: ');
            readln(nombre);
            seek(archivo,0);
            ok:=False;
        end;
        close(archivo);
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

    procedure exportar_sin_stock(var archivo: archivo_maestro);
    var
        reg_m: celular;
        archivo_texto: Text;
    begin
        Assign(archivo_texto,'”SinStock.txt');
        rewrite(archivo_texto);
        reset(archivo);
        while not eof(archivo) do begin
            read(archivo,reg_m);
            if(reg_m.stock_disponible = 00) then
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
        writeln('4.Añadir uno o más celulares al final del archivo con sus datos ingresados por teclado.');
        writeln('5.Modificar el stock de un celular dado.');
        writeln('6.Exportar el contenido del archivo binario a un archivo de texto denominado: ”SinStock.txt”, con aquellos celulares que tengan stock 0.');
        writeln('7.Volver atras');
        writeln('8.Salir');
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
            '4': aniadir_celular(archivo);
            '5': modificar_stock(archivo);
            '6': exportar_sin_stock(archivo);
            '7': exit;
            '8': halt;
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