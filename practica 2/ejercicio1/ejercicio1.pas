{
    Una empresa posee un archivo con información de los ingresos percibidos por diferentes
    empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
    nombre y monto de la comisión. La información del archivo se encuentra ordenada por
    código de empleado y cada empleado puede aparecer más de una vez en el archivo de
    comisiones.
    Realice un procedimiento que reciba el archivo anteriormente descripto y lo compacte. En
    consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
    única vez con el valor total de sus comisiones.
    NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
    recorrido una única vez.

}

program ejercicio1;
const
    valor_corte = 9999;
type

    empleado = record
        cod: integer;
        nombre: string[25];
        monto: real;
    end;

    archivo_maestro = file of empleado;

    procedure imprimir_empleado(var reg_m: empleado);
    begin
        writeln('Nombre: ', reg_m.nombre, #10, 'Codigo de empleado: ', reg_m.cod, #10,'Monto: ', reg_m.monto:2:2,#10);
    end;

    procedure leer_registro(var reg_m:empleado);
    begin
        write('Codigo de empleado: ');
        readln(reg_m.cod);
        if(reg_m.cod <> valor_corte) then begin
            write('Ingrese nombre de empleado: ');
            readln(reg_m.nombre);
            write('Ingrese monto de la comision: ');
            readln(reg_m.monto);
        end;
    end;

    procedure leer(var archivo: archivo_maestro; var reg_m:empleado);
    begin
        if not eof(archivo) then 
            read(archivo,reg_m)
        else
            reg_m.cod:= valor_corte;
    end;

    procedure compactar(var archivoM: archivo_maestro; var archivo_compactado: archivo_maestro);
    var
        reg_aux,reg_m: empleado;
    begin
        rewrite(archivo_compactado);
        reset(archivoM);
        leer(archivoM,reg_m);
        while(reg_m.cod <> valor_corte) do begin
            
            reg_aux.cod:= reg_m.cod;
            reg_aux.monto:= 0;
            reg_aux.nombre := reg_m.nombre;


            while(reg_m.cod = reg_aux.cod) do begin
                reg_aux.monto := reg_aux.monto + reg_m.monto;
                leer(archivoM,reg_m);
            end;
            
            write(archivo_compactado,reg_aux);
        end;
        close(archivoM);
        close(archivo_compactado);
    end;

    procedure imprimir(var archivo: archivo_maestro);
    var
        reg_m:empleado;
    begin
        reset(archivo);
        while not eof(archivo) do begin
            read(archivo,reg_m);
            imprimir_empleado(reg_m);
        end;
        close(archivo);
    end;

    procedure crear_archivo_maestro(var archivoM: archivo_maestro);
    var
        reg_m:empleado;
    begin
        rewrite(archivoM);
        leer_registro(reg_m);
        while(reg_m.cod <> valor_corte) do begin
            write(archivoM,reg_m);
            leer_registro(reg_m);
        end;
        close(archivoM);
    end;

var
    archivoM: archivo_maestro;
    archivo_compactado: archivo_maestro;
    nombre_archivo: string[25];
begin
    write('Ingrese nombre del archivo maestro de la empresa: ');
    readln(nombre_archivo);
    Assign(archivoM,nombre_archivo);
    crear_archivo_maestro(archivoM);
    Assign(archivo_compactado,'compacto');
    compactar(archivoM,archivo_compactado);
    imprimir(archivo_compactado);
end.