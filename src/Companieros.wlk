/*Representa a un companiero cualquiera, como al dia solo tenemos la implementacion de morty,
 * hemos decidido dejarlo sin ningun tipo de metodo, si en la segunda parte no se implementan
 * mas compañeros esta clase sera borrada.
 */
class Companiero {
	/*Energia que tiene el compañero*/
	var energia = 0

	/*La mochila donde lleva sus materiales */
	const mochila = #{} 

	/*Setea energia, es modificada. */
	method modificarEnergia(unaCantidad) {
		energia = ( energia + unaCantidad ).max(0)
	} 
	
	method modificarEnergiaPorMaterial(unaCantidad)
	
	method tamanioMochila()
	
	/*No puede tener mas de 3 materiales en la mochila */
	method hayLugarEnMochila() = mochila.size() < self.tamanioMochila()

	/*Verifica si morty tiene la energia suficiente para recolectar */
	method energiaSuficienteParaRecolectar(unMaterial) = energia >= unMaterial.energiaRequerida()

	/*Nos dice si puede recolectar un material. */
	method puedeRecolectar(unMaterial) = self.hayLugarEnMochila() and self.energiaSuficienteParaRecolectar(unMaterial)
	
	/*Valida si puede hacer la recoleccion de un material, caso contrario arroja un error */
	method validarRecoleccion(unMaterial){
		if (!self.puedeRecolectar(unMaterial)){
			self.error("No se puede recolectar " + unMaterial)
		}
	}

	/*Devuelve el conjunto de materiales */
	method materialesMochila() = mochila
	
	/*Devuelve la energia */
	method energia() = energia
	
	/*Recolecta un material, validando si esto es posible. */
	method recolectar(unMaterial) {
		self.validarRecoleccion(unMaterial)
		mochila.add(unMaterial)
		unMaterial.efectoSobreRecolector(self)
	}
	
	/*Le pasa los objetos a un companiero y vacia su mochila */
	method darObjetosA(unCompanero) {
		unCompanero.recibir(mochila)
		mochila.clear()
	}

	/*efecto que causa rick sobre el compañero */
	method efectoDeRick() {}


	method tirarObjetoAlAzar(){
		mochila.remove(mochila.anyOne())
	}
	
	method modificarEnergiaPorcentual(unPorcentaje) {
			self.modificarEnergia(self.energia() * unPorcentaje / 100)
	}
	
	method recolectarSiPuede(unMaterial){
		if(self.puedeRecolectar(unMaterial)){
			self.recolectar(unMaterial)
		}
	}
	
}


/*Es la implementacion en particular de morty */
object morty inherits Companiero {

	/*retorna el tamaño de la mochila */
	override method tamanioMochila() = 3
	
	override method modificarEnergiaPorMaterial(unaCantidad) {self.modificarEnergia(unaCantidad)}
	
}

object summer inherits Companiero{
	
	/*retorna el tamaño de la mochila */
	override method tamanioMochila() = 2

	/*modifica la energia cuando a */
	override method modificarEnergiaPorMaterial(unaCantidad){
		energia = ( energia + (unaCantidad * 0.8) ).max(0)	}
		
			
	/*Verifica si tiene la energia suficiente para recolectar */
	override method energiaSuficienteParaRecolectar(unMaterial) = energia >= (unMaterial.energiaRequerida() * 0.8 )
	
	/*Le pasa los objetos a un companiero y vacia su mochila */
	override method darObjetosA(unCompanero) {
		super(unCompanero)
		energia -= 10
	}

}

object jerry inherits Companiero{
	
	var estaDeHumor = true
	var sobreexitado = false
	var tamanioMochila = 3
	
	/*setea el tamaño de la mochila */
	method setTamanioMochila(unTamanio){ tamanioMochila = unTamanio}

	/*Sobreescritura del metodo tamanioMochila */
	override method tamanioMochila() = tamanioMochila
	
	/*cambia el humor al valor que le entregue false-true */
	method cambiarHumor(valor) {
		estaDeHumor = valor
	}
	
	override method modificarEnergiaPorMaterial(unaCantidad) {self.modificarEnergia(unaCantidad)}
	
	/*returna el estado de humor */
	method humor() = estaDeHumor
	
	/* */
	method sobreexitado(valor){
		sobreexitado = valor
	}
	
	/*Recolecta un material, validando si esto es posible. */
	override method recolectar(unMaterial) {
		//self.sobreexitar(unMaterial)
		self.validarRecoleccion(unMaterial)
		self.ejecutarPosibilidad()
		mochila.add(unMaterial)
		unMaterial.efectoSobreRecolector(self)
	}
	
	/*si cumple con la posibilidades de dejar caer todo lo que tenía en la mochila hasta ese momento. */
	method ejecutarPosibilidad(){
		if (self.posibilidad() and sobreexitado){
			self.tirarElementosMochila()
			}
	}
	/*vacia la mochila */
	method tirarElementosMochila(){
		mochila.clear()
	}
	
	/*posibilidad de 1/4 */
	method posibilidad() = (1.randomUpTo(4)) == 1
		
	/*puede recolectar hasta el doble de elementos en su mochila */
	method sobreexitar(unMaterial){
		if (!sobreexitado and unMaterial.esRadiactivo()){
			tamanioMochila = tamanioMochila *2
			sobreexitado = true
			
		}
	}
	/*ejecto que causa rick sobre jerry */
	override method efectoDeRick() {
		self.cambiarHumor(false)
	}
	


}