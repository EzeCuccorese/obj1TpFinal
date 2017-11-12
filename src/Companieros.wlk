/*Representa a un companiero cualquiera, como al dia solo tenemos la implementacion de morty,
 * hemos decidido dejarlo sin ningun tipo de metodo, si en la segunda parte no se implementan
 * mas compañeros esta clase sera borrada.
 */
class Companiero {
}

/*Es la implementacion en particular de morty */
object morty inherits Companiero {
	var energia = 0
	const mochila = #{} 
	
	method modificarEnergia(unaCantidad) {
		energia = ( energia + unaCantidad ).max(0)
	} 
	
	/*No puede tener mas de 3 materiales en la mochila */
	method hayLugarEnMochila() = mochila.size() < 3
	
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
}