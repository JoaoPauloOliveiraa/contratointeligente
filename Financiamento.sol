pragma solidity ^0.6.0;

contract Financiamento{
    address payable dono;
	address remetente;
	uint parcelasPagas = 0;
	uint parcelasAtrasadas = 0;
	bool atrasado = false;
	uint dataUltimoPagamento = 0;
	uint valorParcela = 0;

    struct Parte{
   	 string nome;
   	 string cpf;
   	 address id;
    }
    
    event TrocoEnviado(address remetente, uint troco);
    event PagamentoEnviado(address dono, uint valorParcela);

    function pagar() public payable custoParcela(valorParcela) saldoInsuficiente(valorParcela){

    	uint troco = msg.value - valorParcela;
    	valorParcela = valorParcela;
    	
    // 	uint parcela = address(this).balance;
    	dono.transfer(valorParcela);
   	    emit PagamentoEnviado(dono, valorParcela);
   	    
    	if(troco > 0){
        	msg.sender.transfer(troco);
        	emit TrocoEnviado(msg.sender, troco);
    	}
    	
      }

    modifier saldoInsuficiente(uint enviado){
    	require(msg.sender.balance >= enviado, "Você não possui saldo suficiente");
    	_;
    }
    
    modifier custoParcela(uint min){
    	require(msg.value >= min, "Não foi possível efetuar o pagamento, o valor da parcela é maior que o valor enviado");
    	_;
    }
    struct Contrato{
    	int numeroContrato;
   	 string descricao;
   	 uint256 valorBem;
   	 uint qtdParcelas;
   	 uint juros;
   	 uint jurosTotalEmMoeda;
   	 uint valorParcela;
   	 uint valorTotalComJuros;
   	 uint inicio;
    }
    	Contrato[] contratos;
   	 
    	constructor(int _numeroContrato,
                	string memory _descricao,
                	uint256 _valorBem,
                	uint _qtdParcelas,
                	uint _juros) public {
            	contratos.push(Contrato({
            	numeroContrato: _numeroContrato,
            	descricao: _descricao,
            	valorBem: _valorBem,
            	qtdParcelas: _qtdParcelas,
            	juros: _juros,
            	jurosTotalEmMoeda: (_juros * _valorBem)/100,
            	valorParcela: (_valorBem + ((_juros * _valorBem)/100))/_qtdParcelas,
            	valorTotalComJuros: _valorBem + ((_juros * _valorBem)/100),
            	inicio: now
        	}));
        	valorParcela = (_valorBem + ((_juros * _valorBem)/100))/_qtdParcelas;
        	dono = msg.sender;
    	}
   	 
    	function getInfoContrato() public view returns(
        	address _donoDoContrato,
        	int _numeroContrato,
        	string memory _descricao,
        	uint256 _valorBem,
        	uint _qtdParcelas,
        	uint _juros,
        	uint _jurosTotalEmMoedas,
        	uint _valorParcela,
        	uint _valorTotalComJuros,
        	uint _inicio
        	){
		
            	//Contrato memory ultimo = contratos[contratos.length - 1];
           	 
            	return(
                    	dono,
                    	contratos[0].numeroContrato,
                    	contratos[0].descricao,
                    	contratos[0].valorBem,
                    	contratos[0].qtdParcelas,
                    	contratos[0].juros,
                    	contratos[0].jurosTotalEmMoeda,
                    	contratos[0].valorParcela,
                    	contratos[0].valorTotalComJuros,
                    	contratos[0].inicio
                	);
        	}
       	 
    	Parte[] vendedor;
   	 
    	function setVendedor(
    	string memory _nomeVendedor,
    	string memory _cpf)
    	public {
   	 
    	vendedor.push(Parte({
        	id: dono,
        	nome: _nomeVendedor,
        	cpf: _cpf
    	}));
    			 
    	}
    	function getVendedor()
    	view public returns (
    	address _addressVendedor,
    	string memory _nomeVendedor,
    	string memory _cpf) {
        	return(
              	vendedor[0].id,
              	vendedor[0].nome,
              	vendedor[0].cpf
            	);                                            	  	    
    	}
   	 
    	Parte[] comprador;
   	 
   	 function setComprador (
   	 string memory _nomeComprador,
    	string memory _cpfComprador,
    	address _addressComprador
    	)
    	public {
    	    
   	    require(_addressComprador != dono, "O comprador e o vendedor devem possuir endereços diferentes");
    	comprador.push(Parte({
        	id: _addressComprador,
        	nome: _nomeComprador,
        	cpf: _cpfComprador
    	}));
    			 
    	}
    	function getComprador()
    	view public returns (
    	address _addressComprador,
    	string memory _nomeComprador,
    	string memory _cpfComprador) {
        	return(
              	comprador[0].id,
              	comprador[0].nome,
              	comprador[0].cpf
            	);
   	 }
}
