{
    Realizar un programa que presente un menú con opciones para:
        a. Crear un archivo de registros no ordenados de empleados y completarlo con
        datos ingresados desde teclado. De cada empleado se registra: número de
        empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
        DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
        b. Abrir el archivo anteriormente generado y
        i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
        determinado.
        ii.  Listar en pantalla los empleados de a uno por línea.
        iii. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.
        NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario una
        única vez.
}

program ejercicio3;
const
    valor_corte = 'fin';
type

    empleado = record
        numero: integer;
        apellido: string[25];
        nombre: string[25];
        edad: integer;
        dni: string[10];
    end;

    archivo_maestro = file of empleado;

    procedure imprimir_registro(var reg_m: empleado);
    begin
        write('Apellido: ', reg_m.apellido, #10, 'Nombre: ', reg_m.nombre, #10, 'Edad: ', reg_m.edad, #10, 'Dni: ', reg_m.dni, 'Numero de empleado: ', reg_m.numero, #10);
    end;

    procedure listar_nombre(var archivo: archivo_maestro);
    var
        buscar: string[25];
        reg_m: empleado;
        ok: boolean;
    begin
        reset(archivo);
        write('Ingrese nombre o apellido del empleado a buscar: ');
        readln(buscar);
        ok:= False;
        while not eof(archivo) do begin
            read(archivo,reg_m);
            if(reg_m.nombre = buscar) or (reg_m.apellido = buscar) then
                imprimir_registro(reg_m);
                ok:= True;
        end;
        if not (ok) then
            writeln('El empleado no se encontro');
        close(archivo);
    end;

    procedure listar_empleados(var archivo: archivo_maestro);
    var
        reg_m: empleado;
    begin
        reset(archivo);
        while not eof(archivo) do begin
            read(archivo,reg_m);
            imprimir_registro(reg_m);
        end;
        close(archivo);
    end;

    procedure listar_jubilados(var archivo: archivo_maestro);
    var
        reg_m: empleado;
    begin
        reset(archivo);
        while not eof(archivo) do begin
            read(archivo,reg_m);
            if(reg_m.edad >= 70) then
                imprimir_registro(reg_m);
        end;
        close(archivo);
    end;

    procedure imprimir_opciones2();
    begin
        writeln('1.Listar un empleado por nombre o apellido');
        writeln('2.Listar los empleados de a uno por línea');
        writeln('3.Listar empleados mayores de 70 años, próximos a jubilarse.');
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
            '1': listar_nombre(archivo);
            '2': listar_empleados(archivo);
            '3': listar_jubilados(archivo);
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
        writeln('1.Crear archivo de empleados');
        writeln('2.Abrir archivo de empleados');
        writeln('3.Salir');
    end;


    procedure leer_registro(var reg_m: empleado);
    begin
        write('Ingrese apellido de empleado: ');
        readln(reg_m.apellido);
        if (reg_m.apellido <> valor_corte) then begin
            write('Ingrese nombre de empleado: ');
            readln(reg_m.nombre);
            write('Ingrese edad de empleado: ');
            readln(reg_m.edad);
            write('Ingrese dni de empleado: ');
            readln(reg_m.dni);
            write('Ingrese numero de empleado: ');
            readln(reg_m.numero);
        end;
    end;

    procedure crear_archivo(var archivo: archivo_maestro);
    var
        reg_m: empleado;
    begin
        Rewrite(archivo);
        leer_registro(reg_m);
        while(reg_m.apellido <> valor_corte) do begin
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
    nombre_archivo_maestro : string[25];
    archivo : archivo_maestro;
begin
    write('Ingrese nombre del archivo con el que va a trabajar: ');
    readln(nombre_archivo_maestro);
    Assign(archivo,nombre_archivo_maestro);
    menu(archivo);
    close(archivo);
end.