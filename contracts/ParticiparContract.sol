pragma solidity ^ 0.5.8;
contract ParticiparContract {
    
    address admin;
    
    mapping(uint256 => bool) public proyectos;
    mapping(uint256 => TipoVoto) public votosProyectos;
    mapping(address => mapping(uint256 => EnumVoto)) public votosCiudadano;
    struct TipoVoto {
        uint8 favor;
        uint8 neutro;
        uint8 contra;
    }
    
    enum EnumVoto {SIN_VOTAR, FAVOR, NEUTRO, CONTRA} //El valor por defecto de un Enum es el 0, es decir, el valor de la primer posición (SIN_VOTAR)


    /*
       Constructor. Asigna como admin a la address que lo instancie.
    */
    constructor() public{
        admin = msg.sender;
    }

    /*
       Chequea que el address que intenta hacer la transaccion sea el admin.
    */
    modifier soloAdmin {
        require(msg.sender == admin, "Error, solo el Admin puede realizar esta acción");
        _;
    }
    
    /*
       Chequea que el address que intenta hacer la transaccion (el ciudadano que vota), no haya votado ya este proyecto.
    */
    modifier soloSiNoVote(uint256 _id_proyecto) {
        require(votosCiudadano[msg.sender][_id_proyecto] == EnumVoto.SIN_VOTAR , "Error, el ciudadano ya votó este proyecto");
        _;
    }
   
    /*
       Chequea que el proyecto este cargado por el admin.
    */
    modifier soloSiExisteProyecto(uint256 _id_proyecto) {
        require(proyectos[_id_proyecto], "Error, el proyecto no existe");
        _;
    }
    
    /*
        Al llamar a esta función, se inicializa esta clave en el mapping de proyectos.
        Es el workaround que encontré para tener algo similar a un array de proyectos.
        Solo lo puede llamar el Admin.
    */
    function cargarProyecto(uint256 _id_proyecto) public soloAdmin {
        proyectos[_id_proyecto] = true;
    }
    
    function votarAFavor(uint256 _id_proyecto) public soloSiExisteProyecto(_id_proyecto) soloSiNoVote(_id_proyecto) {
        votosProyectos[_id_proyecto].favor += 1;
        votosCiudadano[msg.sender][_id_proyecto] = EnumVoto.FAVOR;
    }

    function votarNeutro(uint256 _id_proyecto) public soloSiExisteProyecto(_id_proyecto) soloSiNoVote(_id_proyecto) {
        votosProyectos[_id_proyecto].neutro += 1;
        votosCiudadano[msg.sender][_id_proyecto] = EnumVoto.NEUTRO;
    }

    function votarEnContra(uint256 _id_proyecto) public soloSiExisteProyecto(_id_proyecto) soloSiNoVote(_id_proyecto) {
        votosProyectos[_id_proyecto].contra += 1;
        votosCiudadano[msg.sender][_id_proyecto] = EnumVoto.CONTRA;
    }
    
    /*
        Para el proyecto recibido por parámetro, retorna:
        - Votos a favor
        - Votos neutros
        - Votos en contra
        - Votos totales sumados
    */
    function getVotosTotales(uint256 _id_proyecto) external view returns(uint8 favor, uint8 neutro, uint8 contra, uint8 total) {
        return (
            votosProyectos[_id_proyecto].favor,
            votosProyectos[_id_proyecto].neutro,
            votosProyectos[_id_proyecto].contra, 
            votosProyectos[_id_proyecto].favor + votosProyectos[_id_proyecto].neutro + votosProyectos[_id_proyecto].contra
            );
    }
    
    /*
        Para el proyecto recibido por parámetro, retorna:
        0 si el ciudadano no votó
        1 si el ciudadano votó a favor
        2 si el ciudadano votó neutro
        3 si el ciudadano votó en contra
    */
    function getMiVoto(uint256 _id_proyecto) external view returns(EnumVoto) {
        return votosCiudadano[msg.sender][_id_proyecto];
    }
    
    
    /*
    function chequearSiVoteA(uint256 _id_proyecto) external view returns(bool) {
        return votosCiudadano[msg.sender][_id_proyecto];
    }
    */
}

