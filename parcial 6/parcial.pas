{
    6- Se desea modelar la información necesaria para un sistema de recuentos de casos de
    covid para el ministerio de salud de la provincia de buenos aires.
    Diariamente se reciben archivos provenientes de los distintos municipios, la información
    contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad casos
    activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
    fallecidos.
    El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
    nombre localidad, código cepa, nombre cepa, cantidad casos activos, cantidad casos
    nuevos, cantidad recuperados y cantidad de fallecidos.
    Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
    recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
    localidad y código de cepa.
    Para la actualización se debe proceder de la siguiente manera:
    1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
    2. Idem anterior para los recuperados.
    3. Los casos activos se actualizan con el valor recibido en el detalle.
    4. Idem anterior para los casos nuevos hallados.
    Realice las declaraciones necesarias, el programa principal y los procedimientos que
    requiera para la actualización solicitada e informe cantidad de localidades con más de 50
    casos activos (las localidades pueden o no haber sido actualizadas).
}

program parcial;
const
    cant_detalles = 10;
    valor_corte = 9999;
type

    maestro = record
        cod_localidad: integer;
        nombre_localidad: string[25];
        cod_cepa: integer;
        nomb_cepa: string[25];
        cant_activos: integer;
        cant_nuevos: integer;
        cant_recuperados: integer;
        cant_fallecidos: integer;
    end;
    
    
    municipio = record
        cod_localidad: integer;
        cod_cepa: integer;
        cant_activos: integer;
        cant_nuevos: integer;
        cant_recuperados: integer;
        cant_fallecidos: integer;
    end;

    archivo_maestro = file of maestro;
    archivo_detalle = file of municipio;

    arreglo_archivo_detalle = array [1..cant_detalles] of archivo_detalle;
    arreglo_registro_detalle = array [1..cant_detalles] of municipio;

    procedure leer(var archivoD: municipio; var reg_d: municipio);
    begin
        if not eof(archivoD) then
            read(archivoD,reg_d)
        else
            reg_d.cod_localidad := valor_corte;
    end;

    procedure minimo(var archivoD: arreglo_archivo_detalle; var arreglo_regD: arreglo_registro_detalle; var min: municipio);
    var
        minPos,i: integer;
    begin
        minPos:= 1;
        min.cod_localidad := valor_corte;
        min.cod_cepa := valor_corte;
        for i:= 1 to cant_detalles do begin
            if(arreglo_regD[i].cod_localidad < min.cod_localidad) then
                if(arreglo_regD[i].cod_cepa < min.cod_cepa) then begin
                    min:= arreglo_regD[i];
                    minPos:= i;
                end;
        end;
      
        leer(archivoD[minPos],arreglo_regD[minPos]);
    end;

    procedure actualizar_maestro(var archivoM: archivo_maestro; var archivoD: arreglo_archivo_detalle);
    var
        reg_m: maestro;
        reg_d: municipio;
        arreglo_regD: arreglo_registro_detalle;
        i:integer;
    begin
        
        for i:= 1 to cant_detalles do begin
            reset(archivoD[i]);
            leer(archivoD[i],arreglo_regD[i]);
        end;

        reset(archivoM);
        minimo(archivoD,arreglo_regD,reg_d);
        while(reg_d.cod_localidad <> valor_corte) do begin
            
            read(archivoM,reg_m);
            while((reg_d.cod_localidad <> reg_m.cod_localidad) and (reg_d.cod_cepa <> reg_m.cod_cepa))do begin
                read(archivoM,reg_m);
            end;
            
            while((reg_d.cod_localidad = reg_m.cod_localidad) and (reg_d.cod_cepa = reg_m.cod_cepa)) do begin
                reg_m.cant_fallecidos := reg_m.cant_fallecidos + reg_d.cant_fallecidos;
                reg_m.cant_recuperados := reg_m.cant_recuperados + reg_d.cant_recuperados;
                reg_m.cant_activos := reg_m.cant_activos + reg_d.cant_activos;
                reg_m.cant_nuevos := reg_m.cant_nuevos + reg_d.cant_nuevos;
                minimo(archivoD,arreglo_regD,reg_d);
            end;

            seek(archivoM,filepos(archivoM)-1);
            write(archivoM,reg_m);
        
        end;

        for i:= 1 to cant_detalles do begin
            close(archivoD[i]);
        end;

        close(archivoM);
    end;

var
    i:integer;
    i_str: string;
    archivoM: archivo_maestro;
    archivoD: arreglo_archivo_detalle;
begin
    Assign(archivoM,'maestro');
    for i:= 1 to cant_detalles do begin
        Str(i,i_str);
        Assign(archivoD[i],'Detalle ' + i_str);
    end;
    actualizar_maestro(archivoM,archivoD);
end.