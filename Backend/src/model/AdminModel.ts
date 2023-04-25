import MysqlDBC from "../db/myslq/MysqlDBC";


export default class UserModel {

    private mysqlDBC: MysqlDBC;

    constructor() {
        this.mysqlDBC = new MysqlDBC();
    }
    
    public InsertCategoriaTrabajo = async (nombre: string, fn: Function) => {
        this.mysqlDBC.connection();

        const statement = `INSERT INTO categorias(nombres) VALUES ("${nombre}");`;
        this.mysqlDBC.pool.query(statement, (error: any, rows: any) => {
            fn(error, rows);
        }); 
       
    }

    public DeleteCategoriaTrabajo = async (nombre: string, fn: Function) => {
        this.mysqlDBC.connection();

        const statement = `DELETE FROM categorias WHERE nombres="${nombre}";`;
        this.mysqlDBC.pool.query(statement, (error: any, rows: any) => {
            fn(error, rows);
        }); 
       
    }

   

}