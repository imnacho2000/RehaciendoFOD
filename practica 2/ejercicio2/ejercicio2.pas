{

    Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
    cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
    (cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
    un archivo detalle con el código de alumno e información correspondiente a una materia
    (esta información indica si aprobó la cursada o aprobó el final).
    Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
    haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
    programa con opciones para:
    a. Actualizar el archivo maestro de la siguiente manera:
    i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado.
    ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
    final.
    b. Listar en un archivo de texto los alumnos que tengan más de cuatro materias
    con cursada aprobada pero no aprobaron el final. Deben listarse todos los campos.
    NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez.

}

program ejercicio2;
const
    valor_corte = 9999;
type
    alumno = record
        cod:integer;
        apellido: string[25];
        nombre: string[25];
        cant_sin_final: integer;
        cant_con_final: integer;
    end;

    alumno_detalle = record
        cod: integer;
        aprobo: char;
    end;

    archivo_maestro = file of alumno;
    archivo_detalle = file of alumno_detalle;


    //Leyendo Alumnos e imprimiendo su informacion.

    procedure leer_alumno(var reg_m: alumno);
    begin
        write('Ingrese codigo de alumno: ');
        readln(reg_m.cod);
        if(reg_m.cod <> valor_corte) then begin
            write('Ingrese nombre de alumno: ');
            readln(reg_m.nombre);
            write('Ingrese apellido de alumno: ');
            readln(reg_m.apellido);
            write('Ingrese cantidad de materias sin final de alumno: ');
            readln(reg_m.cant_sin_final);
            write('Ingrese cantidad de materias con final de alumno: ');
            readln(reg_m.cant_con_final);
        end;
    end;

    procedure leer_alumno_detalle(var reg_d: alumno_detalle);
    begin
        write('Ingrese codigo de alumno: ');
        readln(reg_d.cod);
        if(reg_d.cod <> valor_corte) then begin
            write('Ingrese si aprobo: ');
            readln(reg_d.aprobo);
        end;
    end;


    procedure imprimir_alumno(var reg_m:alumno);
    begin
        write('Codigo de alumno: ', reg_m.cod, #10, 'Nombre: ', reg_m.nombre, #10, 'Apellido: ', reg_m.apellido, #10, 'Cantidad de materias sin final: ', reg_m.cant_sin_final, #10,'Cantidad de materias con final: ', reg_m.cant_con_final, #10);
    end;

    /////////////////////////////////////////////////
        // Creacion de archivos
    /////////////////////////////////////////////////

    procedure crear_maestro(var archivo: archivo_maestro);
    var
        reg_m:alumno;
    begin
        rewrite(archivo);
        leer_alumno(reg_m);
        while(reg_m.cod <> valor_corte) do begin
            write(archivo,reg_m);
            leer_alumno(reg_m);
        end;
        close(archivo);
    end;


    procedure crear_detalle(var archivo: archivo_detalle);
    var
        reg_d:alumno_detalle;
    begin
        rewrite(archivo);
        leer_alumno_detalle(reg_d);
        while(reg_d.cod <> valor_corte) do begin
            write(archivo,reg_d);
            leer_alumno_detalle(reg_d);
        end;
        close(archivo);
    end;

    /////////////////////////////////////////////////
        // recorridos
    /////////////////////////////////////////////////

    procedure leer_detalle(var archivoD: archivo_detalle; var reg_d: alumno_detalle);
    begin
        if not eof(archivoD) then
            read(archivoD,reg_d)
        else
            reg_d.cod := valor_corte;
    end;

    procedure actualizar_maestro(var archivoM: archivo_maestro; var archivoD: archivo_detalle);
    var
        reg_m: alumno;
        reg_d: alumno_detalle;
    begin
        reset(archivoM);
        reset(archivoD);
        leer_detalle(archivoD,reg_d);
        while(reg_d.cod <> valor_corte) do begin
            read(archivoM,reg_m);
            while(reg_d.cod <> reg_m.cod) do begin
                read(archivoM,reg_m);
            end;

            while (reg_d.cod = reg_m.cod) do begin

                if(reg_d.aprobo = 'A') then 
                    reg_m.cant_con_final:= reg_m.cant_con_final + 1
                else
                    reg_m.cant_sin_final:= reg_m.cant_sin_final + 1;

                leer_detalle(archivoD,reg_d);
            end;    

            seek(archivoM,filepos(archivoM)-1);
            write(archivoM,reg_m);

        end;
        close(archivoM);
        close(archivoD);
    end;

    procedure crear_texto(var archivoM: archivo_maestro);
    var
        archivo_text: Text;
        reg_m:alumno;
    begin
        Assign(archivo_text,'alumnos.txt');
        rewrite(archivo_text);
        reset(archivoM);
        while not eof(archivoM) do begin
            read(archivoM,reg_m);
            if(reg_m.cant_con_final > 4) then 
                write(archivo_text,'Codigo de alumno: ', reg_m.cod, #10, 'Nombre: ', reg_m.nombre, #10, 'Apellido: ', reg_m.apellido, #10, 'Cantidad de materias sin final: ', reg_m.cant_sin_final, #10,'Cantidad de materias con final: ', reg_m.cant_con_final, #10);
        end;
        close(archivoM);
        close(archivo_text);
    end;

    /////////////////////////////////////////////////
        // imprimiiendo archivos
    /////////////////////////////////////////////////

    procedure imprimir_maestro(var archivoM: archivo_maestro);
    var
        reg_m: alumno;
    begin
        reset(archivoM);
        while not eof(archivoM) do begin
            read(archivoM,reg_m);
            imprimir_alumno(reg_m);
        end;
        close(archivoM);
    end;


var
    nombre_archivo_maestro: string[25];
    nombre_archivo_detalle: string[25];

    archivoD: archivo_detalle;
    archivoM: archivo_maestro;

begin
    write('Ingrese nombre de archivo maestro: ');
    readln(nombre_archivo_maestro);
    Assign(archivoM,nombre_archivo_maestro);

    write('Ingrese nombre de archivo detalle: ');
    readln(nombre_archivo_detalle);
    Assign(archivoD,nombre_archivo_detalle);

    actualizar_maestro(archivoM,archivoD);
    crear_texto(archivoM);
    

end.