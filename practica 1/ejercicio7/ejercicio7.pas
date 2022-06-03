{
    7. Realizar un programa que permita:
        a. Crear un archivo binario a partir de la información almacenada en un archivo de texto.
        El nombre del archivo de texto es: “novelas.txt”
        b. Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar
        una novela y modificar una existente. Las búsquedas se realizan por código de novela.
        NOTA: La información en el archivo de texto consiste en: código de novela,
        nombre,género y precio de diferentes novelas argentinas. De cada novela se almacena la
        información en dos líneas en el archivo de texto. La primera línea contendrá la siguiente
        información: código novela, precio, y género, y la segunda línea almacenará el nombre
        de la novela.

}

program ejercicio7;
const
    valor_corte = -1;
type
    
    novela = record
        cod: integer;
        nombre: string[25];
        genero: string[25];
        precio: real;
    end;

    archivo_maestro = file of novela;

    procedure leer_registro(var reg_m: novela);
    begin
        write('Ingrese codigo de novela: ');
        readln(reg_m.cod);
        if (reg_m.cod <> valor_corte) then begin
            write('Ingrese nombre de novela: ');
            readln(reg_m.nombre);
            write('Ingrese genero de novela: ');
            readln(reg_m.genero);
            write('Ingrese precio de novela: ');
            readln(reg_m.precio);
        end;
    end;

    procedure agregar_novela(var archivo: archivo_maestro);
    var
        reg_m: novela;
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

    procedure imprimir_menu_modificaciones();
    begin
        writeln('1.Modificar precio');
        writeln('2.Modificar nombre');
        writeln('3.Modificar genero');
        writeln('4.Volver atras');
    end;

    procedure modificar_precio(var reg_m:novela);
    var
        precio: real;
    begin
        write('Ingrese precio: ');
        readln(precio);
        reg_m.precio := precio;
    end;

    procedure modificar_nombre(var reg_m: novela);
    var
        nombre: string;
    begin
        write('Ingrese nombre: ');
        readln(nombre);
        reg_m.nombre := nombre;
    end;

    procedure modificar_genero(var reg_m: novela);
    var
        genero: string;
    begin
        write('Ingrese nombre: ');
        readln(genero);
        reg_m.genero := genero;
    end;

    procedure menu_modificaciones(var reg_m: novela);
    var
        seleccion:string;
    begin
        imprimir_menu_modificaciones();
        write('Ingrese su opcion a modificar: ');
        readln(seleccion);
        case seleccion of
            '1': modificar_precio(reg_m);
            '2': modificar_nombre(reg_m);
            '3': modificar_genero(reg_m);
            '4': exit;
            else begin
                write('Ingrese una opcion valida.');
                menu_modificaciones(reg_m);
            end;
        end;
        menu_modificaciones(reg_m);
    end;

    procedure modificar_novela(var archivo: archivo_maestro);
    var
        reg_m: novela;
        cod: integer;
        ok: boolean;
    begin
        write('Ingrese codigo de novela: ');
        readln(cod);
        reset(archivo);
        ok:= False;
        while not eof(archivo) do begin
            read(archivo,reg_m);
            if(reg_m.cod = cod) then begin
                menu_modificaciones(reg_m);
                seek(archivo,filepos(archivo)-1);
                write(archivo,reg_m);
                ok:= True;
            end;
        end;
        if not(ok) then
            write('La novela con codigo: ', cod, ' no existe.');
        close(archivo);
    end;


    procedure imprimir_menu2();
    begin
        writeln('1.Agregar novela');
        writeln('2.Modificar novela');
        writeln('3.Imprimir uno por uno por linea');
        writeln('4.Volver atras');
        writeln('5.Salir');
    end;

    procedure imprimir_novela(var reg_m: novela);
    begin
        write('Codigo: ', reg_m.cod,#10, 'Nombre: ', reg_m.nombre, #10, 'Genero: ', reg_m.genero, #10, 'Precio: ', reg_m.precio:2:2, #10);
    end;

    procedure imprimir(var archivo: archivo_maestro);
    var
        reg_m: novela;
    begin
        reset(archivo);
        while not eof(archivo) do begin
            read(archivo,reg_m);
            imprimir_novela(reg_m);
        end;
        close(archivo);
    end;

    procedure menu2(var archivo: archivo_maestro);
    var
        seleccion:string;
    begin
        imprimir_menu2();
        write('Ingrese opcion: ');
        readln(seleccion);
        case seleccion of
            '1': agregar_novela(archivo);
            '2': modificar_novela(archivo);
            '3': imprimir(archivo);
            '4': exit;
            '5': halt;
            else begin
                write('Ingrese una opcion correcta');
                menu2(archivo);
            end;
        end;
        menu2(archivo);
    end;


    procedure crear_binario(var archivo_text: Text; var archivo: archivo_maestro);
    var
        reg_m: novela;
    begin
        rewrite(archivo);
        reset(archivo_text);
        while not eof(archivo_text) do begin
            readln(archivo_text,reg_m.cod,reg_m.precio,reg_m.genero);
            readln(archivo_text,reg_m.nombre);
            write(archivo,reg_m);
        end;
        close(archivo_text);
        close(archivo);
    end;

    procedure imprimir_menu();
    begin
        writeln('1.Crear archivo binario a partir de un txt de novelas.txt');
        writeln('2.Abrir archivo binario');
        writeln('3.Salir');
    end;

    procedure menu(var archivo_text: Text; var archivo: archivo_maestro);
    var
        seleccion:string;
    begin
        imprimir_menu();
        write('Ingrese opcion: ');
        readln(seleccion);
        case seleccion of
            '1': crear_binario(archivo_text,archivo);
            '2': menu2(archivo);
            '3': halt;
            else begin
                write('Ingrese una opcion correcta');
                menu(archivo_text,archivo);
            end;
        end;
        menu(archivo_text,archivo);
    end;

var
    archivo: archivo_maestro;
    archivo_text: Text;
    nombre: string[25];
begin
    write('Ingrese el nombre con el archivo binario de novela a crear: ');
    readln(nombre);
    Assign(archivo_text,'novelas.txt');
    Assign(archivo,nombre);
    menu(archivo_text,archivo);
    close(archivo);
    close(archivo_text);
end.