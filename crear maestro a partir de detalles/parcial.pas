program parcial;
const
    cant_detalles = 3;
    valor_corte = 9999;
type

    informacion = record
        cod_repuesto: integer;
        nombre_repuesto: string[25];
        cantidad_vendida: integer;
        fechaYhora_venta: string[25];
    end;

    nuevo_archivo = record
        cod_repuesto: integer;
        nombre_repuesto: string[25];
        cantidad_total_vendida: integer;
    end;

    archivo_detalle = file of informacion;
    archivo_maestro = file of nuevo_archivo;

    arreglo_archivo_detalle = array [1..cant_detalles] of archivo_detalle;
    arreglo_reg_d = array[1..cant_detalles] of informacion;

    procedure leer(var archivoD: archivo_detalle; var reg_d: informacion);
    begin
        if not eof(archivoD) then
            read(archivoD,reg_d)
        else
            reg_d.cod_repuesto := valor_corte;
    end;

    procedure minimo(var arreglo_archivoD:arreglo_archivo_detalle; var arreglo_regD:arreglo_reg_d; var min: informacion);
    var
        i,minPos: integer;
    begin
        minPos:= 1;
        min.cod_repuesto := 9999;
        for i:= 1 to cant_detalles do begin
            if(arreglo_regD[i].cod_repuesto < min.cod_repuesto) then begin
                minPos:= i;
                min:= arreglo_regD[i];
            end;
        end;

        if(min.cod_repuesto <> valor_corte) then
            leer(arreglo_archivoD[minPos],arreglo_regD[minPos]);
    end;

    procedure actualizar_maestro(var archivoM: archivo_maestro; var archivoD: arreglo_archivo_detalle);
    var
        reg_m: nuevo_archivo;
        reg_d: informacion;
        arreglo_regD: arreglo_reg_d;
        i,cant_total:integer;
    begin
        for i:= 1 to cant_detalles do begin
            reset(archivoD[i]);
            leer(archivoD[i],arreglo_regD[i]);
        end;

        rewrite(archivoM);
        minimo(archivoD,arreglo_regD,reg_d);
        while(reg_d.cod_repuesto <> valor_corte) do begin

            reg_m.cod_repuesto := reg_d.cod_repuesto;
            reg_m.nombre_repuesto:= reg_d.nombre_repuesto;
            cant_total:= 0;

            while(reg_m.cod_repuesto = reg_d.cod_repuesto) do begin
                cant_total := cant_total + reg_d.cantidad_vendida;
                minimo(archivoD,arreglo_regD,reg_d);
            end;

            reg_m.cantidad_total_vendida:= cant_total;
            write(archivoM,reg_m);

        end;
        for i:= 1 to cant_detalles do begin
            close(archivoD[i]);
        end;
        close(archivoM);
    end;

var
    archivoM: archivo_maestro;
    archivoD: arreglo_archivo_detalle;
begin
    Assign(archivoM,'total_repuestos_vendidos.dat');
    // crear_archivos_detalles(archivoD); // se dispone
    actualizar_maestro(archivoM,archivoD);
end.