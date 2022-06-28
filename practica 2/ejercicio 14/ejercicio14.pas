{
    14. Una compañía aérea dispone de un archivo maestro donde guarda información sobre
    sus próximos vuelos. En dicho archivo se tiene almacenado el destino, fecha, hora de salida
    y la cantidad de asientos disponibles. La empresa recibe todos los días dos archivos detalles
    para actualizar el archivo maestro. En dichos archivos se tiene destino, fecha, hora de salida
    y cantidad de asientos comprados. Se sabe que los archivos están ordenados por destino
    más fecha y hora de salida, y que en los detalles pueden venir 0, 1 ó más registros por cada
    uno del maestro. Se pide realizar los módulos necesarios para:
    c. Actualizar el archivo maestro sabiendo que no se registró ninguna venta de pasaje
    sin asiento disponible.
    d. Generar una lista con aquellos vuelos (destino y fecha y hora de salida) que
    tengan menos de una cantidad específica de asientos disponibles. La misma debe
    ser ingresada por teclado.
    
    NOTA: El archivo maestro y los archivos detalles sólo pueden recorrerse una vez

}
program ejercicio14;
const
    cant_detalles = 2;
    valor_alto = 'ZZZ';
type
    
    fechas = record
        dia: 1..31;
        mes: 1..12;
        anio: integer;
    end;

    vuelo = record
        destino: string[25];
        fecha: fechas;  
        hora: string[25];
        cant_asientos:integer;          
    end;
    
    detalle = record
        destino: string[25];
        fecha: fechas;
        hora: string[25];
        cant_asientos: integer;
    end;


    archivo_detalle = file of detalle;
    archivo_maestro = file of vuelo;

    arreglo_archivo_detalle = array [1..cant_detalles] of archivo_detalle;
    arreglo_registro_detalle = array [1..cant_detalles] of detalle;

    procedure leer(var archivo: arreglo_archivo_detalle; var regD: detalle);
    begin
        if not eof(archivo) then
            read(archivo,regD)
        else
            regD.destino := valor_alto;
    end;

    procedure minimo(var archivo: arreglo_archivo_detalle; var registros: arreglo_registro_detalle; var min: detalle);
    var
        pos,i:integer;
    begin
        pos:= 1;
        min.destino := valor_alto;
        min.fecha.dia := 31;
        min.fecha.mes := 12;
        min.fecha.anio := 9999;
        min.hora := valor_alto;
        
        for i:= 1 to cant_detalles do begin
            if(registros[i].destino < min.destino) then
                if(registros[i].fecha.dia < min.fecha.dia) and (registros[i].fecha.mes < min.fecha.mes) and (registros[i].fecha.anio < min.anio)  then
                    if(registros[i].hora < min.hora) then begin
                        min:= registros[i];
                        pos:= i;
                    end;
        end;

        if(min.destino <> valor_alto) then
            leer(archivo[pos],registros[pos]);
    end;

    procedure imprimir_registro(regM: veulo);
    begin
        writeln('Destino: ', regM.destino,#10,'Dia: ',regM.fecha.dia,#10,'Mes: ', regM.fecha.mes,#10,'Anio: ',regM.fecha.anio,#10,'Hora: ',regM.hora,#10);
    end;


    procedure actualizar_maestro(var m:maestro; var d:detalle; asientos:integer);
    var  
        registros: arreglo_registro_detalle;
        regM: vuelo; 
        min: detalle;
        i,total_asientos:integer;
    begin
        for i:= 1 to cant_detalles do begin
            reset(d);
            leer(d[i],registros[i]);
        end;
        reset(m);
        minimo(d,registros,min);
        while(min.destino <> valor_alto) do begin
            total_asientos:=0;
            read(m,regM);
            while(regM.destino <> min.destino) do
                read(m,regM);
            
            while (regM.destino = min.destino) and (regM.fecha.dia = min.fecha.dia) and (regM.fecha.mes = min.fecha.mes) and (regM.fecha.anio = min.fecha.anio) and (regM.hora = min.hora) do begin
                total_asientos:= total_asientos + min.cant_asientos;
                minimo(d,registros,min);
            end;
            regM.cant_asientos := regM.cant_asientos - total_asientos;
            seek(m,filepos(m)-1);
            write(m,regM);

            if(asientos > regM.cant_asientos) then
                imprimir_registro(regM);
        end;
        for i:= 1 to cant_detalles do begin
            close(d[i]);
        end;
        close(m);
    end;
var
    archivoM: archivo_maestro;
    archivoD: arreglo_archivo_detalle;
    i,asientos: integer;
    i_str: string[25];
begin
    Assign(archivoM,'maestro');
    for i:= 1 to cant_detalles do begin
        Str(i,i_str);
        Assign(archivoD,'Detalle: ' + i_str);
    end;
    write('Ingrese un numero de asientos: ');
    readln(asientos);
    actualizar_maestro(archivoM,archivoD,asientos);
end.