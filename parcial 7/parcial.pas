program parcial;
const
    valor_corte = 9999;
type

    venta = record
        sucursal: integer;
        nombre: string[25];
        tipo_producto: string[25];
        cant_vendida: integer;
        precio: real;
    end;

    archivo_maestro = file of venta;

    procedure leer(var archivo: archivo_maestro; var reg_m: venta);
    begin
        if not eof(archivo) then
            read(archivo, reg_m)
        else
            reg_m.sucursal := valor_corte;
    end;

    procedure informar(var archivo: archivo_maestro);
    var
        reg_m: venta;
        total_sucursales,total_sucursal,total_producto,monto_producto: real;
        sucursal: integer;
        nombre,tipo_producto: string[25];
    begin
        reset(archivo);
        read(archivo,reg_m);
        total_sucursales := 0;
        while(reg_m.sucursales <> valor_corte) do begin
            sucursal := reg_m.sucursales;
            total_sucursal := 0;
            while(sucursal = reg_m.sucursal) do begin
                write('Sucursal: ', sucursal);
                tipo_producto := reg_m.tipo_producto;
                total_producto := 0;
                while((sucursal = reg_m.sucursal) and (tipo_prodcuto = reg_m.tipo_producto)) do begin
                    write('Tipo de producto: ', tipo_producto);
                    nombre:= reg_m.nombre;
                    monto_producto := 0;
                    while ((sucursal = reg_m.sucursal) and (tipo_prodcuto = reg_m.tipo_producto) and (nombre = reg_m.nombre)) do begin
                        monto_producto = monto_prodcuto + (reg_m.precio * reg_m.cant_vendida);
                        write('Monto de producto: ', (reg_m.precio * reg_m.cant_vendida),' Cantidad vendida: ', reg_m.cant_vendida);
                    end;
                    total_producto:= total_producto + monto_producto;
                end;
                write('Monto total del producto: ', total_producto);
                total_sucursal := total_sucursal + total_producto;
            end;
            write('Total sucursal: ', total_sucursal);
            total_sucursales := total_sucursales + total_sucursal;
        end;
        write('Total sucursales: ', total_sucursal);
        close(archivo);
    end;

var
    archivo: archivo_maestro;
begin
    Assign(archivo,'maestro');
    informar(archivo);
end.