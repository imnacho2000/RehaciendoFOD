program parcial;
const
    cant_detalles = 3;
    valor_corte = 9999;
type
    producto = record
        cod: integer;
        nombre: string[25];
        descripcion: string[25];
        codigo_barras: integer;
        categoria: integer;
        stock_actual: integer;
        stock_minimo: integer;
    end;
    
    pedido = record
        cod: integer;
        cant: integer;
        descripcion: string[25];
    end;

    archivo_maestro = file of producto;
    archivo_detalle = file of pedido;

    arreglo_archivo_detalle = array[1..cant_detalles] of archivo_detalle;
    arreglo_registro_detalle = array[1..cant_detalles] of pedido;

    procedure leer(var archivoD: archivo_detalle; var reg_d: pedido);
    begin
        if not eof(archivoD) then
            read(archivoD,reg_d)
        else
            reg_d.cod := valor_corte;
    end;

    procedure minimo(var arreglo_archivoD:arreglo_archivo_detalle; var arreglo_regD: arreglo_registro_detalle; var min: pedido);
    var
        i,minPos:integer;
    begin
        minPos:= 1;
        min.cod := 9999;
        for i:= 1 to cant_detalles do begin
            if(arreglo_regD[i].cod < min.cod) then begin
                min:= arreglo_regD[i];
                minPos:= i;
            end;
        end;

        if(min.cod <> valor_corte) then
            leer(arreglo_ArchivoD[minPos],arreglo_regD[minPos]);
    end;

    procedure actualizar_maestro(var archivoM: archivo_maestro; var archivoD: arreglo_archivo_detalle);
    var
        arreglo_regD: arreglo_registro_detalle;
        reg_d: pedido;
        reg_m: producto;
        i,dif:integer;
    begin   
        for i:= 1 to cant_detalles do begin
            reset(archivoD[i]);
            leer(archivoD[i],arreglo_regD[i]);
        end;

        reset(archivoM);
        minimo(archivoD,arreglo_regD,reg_d);
        while(reg_d.cod <> valor_corte) do begin
            dif:= 0;
            read(archivoM,reg_m);
            while(reg_m.cod <> reg_d.cod) do begin
                read(archivoM,reg_m);
            end;

            while(reg_d.cod = reg_m.cod) do begin
                if((reg_m.stock_actual - reg_d.cant) > 0) then
                    reg_m.stock_actual := reg_m.stock_actual - reg_d.cant
                else
                    dif:= reg_m.stock_actual - reg_d.cant;
                    reg_m.stock_actual := 0;
                minimo(archivoD,arreglo_regD,reg_d);
            end;

            if(reg_m.stock_actual < reg_m.stock_minimo) then begin
                seek(archivoM,filepos(archivoM)-1);
                write(archivoM,reg_m);
                write('El producto con codigo: ', reg_m.cod, ' pertenece a la categoria: ', reg_m.categoria)
            end
            else 
                if(reg_m.stock_actual = 0) then begin
                    write('La diferencia es: ', dif);
                end;

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
    // Assign(archivoM,'maestro'); // se dispone
    // crear_archivo_detalle(archivoD); // se dispone
    actualizar_maestro(archivoM,archivoD);
end.