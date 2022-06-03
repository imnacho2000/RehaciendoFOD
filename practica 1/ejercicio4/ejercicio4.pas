{
    Agregar al menú del programa del ejercicio 3, opciones para:
        a. Añadir una o más empleados al final del archivo con sus datos ingresados por
        teclado.
        b. Modificar edad a una o más empleados.
        c. Exportar el contenido del archivo a un archivo de texto llamado
        “todos_empleados.txt”.
        d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
        que no tengan cargado el DNI (DNI en 00).
        NOTA: Las búsquedas deben realizarse por número de empleado.

}

program ejercicio4;
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


    procedure imprimir_registro(var reg_m: empleado);
    begin
        write(#10,'Apellido: ', reg_m.apellido, #10, 'Nombre: ', reg_m.nombre, #10, 'Edad: ', reg_m.edad, #10, 'Dni: ', reg_m.dni, #10, 'Numero de empleado: ', reg_m.numero, #10);
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

    procedure aniador_empleado(var archivo: archivo_maestro);
    var
        reg_m: empleado;
    begin
        reset(archivo);
        seek(archivo,filesize(archivo));
        leer_registro(reg_m);
        while(reg_m.apellido <> valor_corte) do begin
            write(archivo,reg_m);
            leer_registro(reg_m);
        end;
        close(archivo);
    end;

    procedure modificar_edad(var archivo: archivo_maestro);
    var
        reg_m: empleado;
        nro,edad: integer;
        ok: boolean;
    begin
        reset(archivo);
        write('Ingrese numero de empleado para modificar la edad: ', #10, ' Ingrese -1 para dejar de modificar. ');
        readln(nro);
        ok:= False;
        while(nro <> -1) do begin
            while not (eof(archivo)) do begin
                read(archivo,reg_m);
                if(reg_m.numero = nro) then begin
                    write('Se encontro el empleado!, su edad es:', reg_m.edad, #10, ' Ingrese edad para modificarsela: ');
                    readln(edad);
                    reg_m.edad := edad;
                    seek(archivo,filepos(archivo)-1);
                    write(archivo,reg_m);
                    ok:= True;
                end;
            end;
            if not (ok) then 
                writeln('El empleado con numero ', edad, ' no se encontro');
           write('Ingrese numero de empleado para modificar la edad: ', #10, ' Ingrese -1 para dejar de modificar. ');
            readln(nro);
            seek(archivo,0);
            ok:=False;
        end;
        close(archivo);
    end;

    procedure exportar_todos_empleado(var archivo: archivo_maestro);
    var
        reg_m: empleado;
        archivo_texto: Text;
    begin
        Assign(archivo_texto,'“todos_empleados.txt');
        rewrite(archivo_texto);
        reset(archivo);
        while not eof(archivo) do begin
            read(archivo,reg_m);
            write(archivo_texto,'Numero: ', reg_m.numero, #10, 'Dni: ', reg_m.dni, #10, 'Nombre: ', reg_m.nombre, #10, 'Apellido: ', reg_m.apellido, #10);
        end;
        close(archivo);
        close(archivo_texto);
    end;

    procedure exportar_empleado_faltantes(var archivo: archivo_maestro);
    var
        reg_m: empleado;
        archivo_texto: Text;
    begin
        Assign(archivo_texto,'faltaDNIEmpleado.txt');
        rewrite(archivo_texto);
        reset(archivo);
        while not eof(archivo) do begin
            read(archivo,reg_m);
            if(reg_m.dni = '00') then
                write(archivo_texto,'Numero: ', reg_m.numero, #10, 'Dni: ', reg_m.dni, #10, 'Nombre: ', reg_m.nombre, #10, 'Apellido: ', reg_m.apellido, #10);
        end;
        close(archivo);
        close(archivo_texto);
    end;

    procedure imprimir_opciones2();
    begin
        writeln('1.Listar un empleado por nombre o apellido');
        writeln('2.Listar los empleados de a uno por línea');
        writeln('3.Listar empleados mayores de 70 años, próximos a jubilarse.');
        writeln('4.Aniadir empleado');
        writeln('5.Modificar edad');
        writeln('6.Exportar a txt');
        writeln('7.Exportar a txt los empleados que no tengan el dni cargado');
        writeln('8.Volver atras');
        writeln('9.Salir');
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
            '4': aniador_empleado(archivo);
            '5': modificar_edad(archivo);
            '6': exportar_todos_empleado(archivo);
            '7': exportar_empleado_faltantes(archivo);
            '8': exit;
            '9': halt;
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