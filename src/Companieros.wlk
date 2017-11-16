/*Representa a un companiero cualquiera, como al dia solo tenemos la implementacion de morty,
 * hemos decidido dejarlo sin ningun tipo de metodo, si en la segunda parte no se implementan
 * mas compañeros esta clase sera borrada.
 */
class Morty {
	/*Energia que tiene el compañero*/
	var energia = 0

	/*La mochila donde lleva sus materiales */
	const mochila = #{} 

	/*Setea energia, es modificada. */
	method modificarEnergia(unaCantidad) {
		energia = ( energia + unaCantidad ).max(0)
	} 
	
	method modificarEnergiaPorMaterial(unaCantidad) {self.modificarEnergia(unaCantidad)}
	
	method tamanioMochila() = 3
	
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

	/*tira un objeto de la mochila */
	method tirarObjetoAlAzar(){
		mochila.remove(mochila.anyOne())
	}
	
	method modificarEnergiaPorcentual(unPorcentaje) {
			self.modificarEnergia(self.energia() * unPorcentaje / 100)
	}
	
	/*recolecta el material si puede recolectarlo */
	method recolectarSiPuede(unMaterial){
		if(self.puedeRecolectar(unMaterial)){
			self.recolectar(unMaterial)
		}
	}
	
}


object summer inherits Morty{
	
	/*retorna el tamaño de la mochila */
	override method tamanioMochila() = 2

	/*modifica la energia cuando a */
	override method modificarEnergiaPorMaterial(unaCantidad){ energia = ( energia + (unaCantidad * 0.8) ).max(0)	}
		
			
	/*Verifica si tiene la energia suficiente para recolectar */
	override method energiaSuficienteParaRecolectar(unMaterial) = energia >= (unMaterial.energiaRequerida() * 0.8 )
	
	/*Le pasa los objetos a un companiero y vacia su mochila */
	override method darObjetosA(unCompanero) {
		super(unCompanero)
		energia -= 10
	}

}

object jerry inherits Morty{
	
	var exitacion = tranquilo
	var humor = buenHumor

	/*setea la exitacion */
	method exitacion(unEstado){ exitacion = unEstado}


	
	/*vacia la mochila */
	method tirarElementosMochila(){
		mochila.clear()
	}
	
	/*sobreescritura tamanio mochula, devulve el tamanio de la mochila segun el estad de humor y la exitacion */
	override method tamanioMochila() = exitacion.tamanio(humor.tamanio())

	/*Recolecta un material, validando si esto es posible. */
	override method recolectar(unMaterial) {
		self.validarRecoleccion(unMaterial)
		exitacion.ejecutarPosibilidad(self, unMaterial)
		mochila.add(unMaterial)
		unMaterial.efectoSobreRecolector(self)
		if(unMaterial.estaVivo()) humor = buenHumor
	}

	/*Le pasa los objetos a un companiero y vacia su mochila */
	override method darObjetosA(unCompanero) {
		unCompanero.recibir(mochila)
		mochila.clear()
		humor = malHumor
	}
}



object tranquilo{
	
	method tamanio(unaCantidad) = unaCantidad
	
	/*si el material es radiactivo se sobreexita */
	method ejecutarPosibilidad(unCompaniero, unMaterial){
		if (unMaterial.esRadiactivo()){
			unCompaniero.exitacion(sobreExitado)
		}
	}
}

object sobreExitado{	
	
	/*posibilidad de 1/4 */
	method posibilidad() = (1.randomUpTo(4)) == 1
	
	method tamanio(unaCantidad) = unaCantidad * 2

	/*si cumple con la posibilidades de dejar caer todo lo que tenía en la mochila hasta ese momento. */
	method ejecutarPosibilidad(unCompaniero, unMaterial){
		if (self.posibilidad()){
			unCompaniero.tirarElementosMochila()
		}
	}
}

object buenHumor{
	method tamanio() = 3
}

object malHumor{
	method tamanio() = 1
}