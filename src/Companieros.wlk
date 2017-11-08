class Companiero {
}

object morty inherits Companiero {
	var energia
	const mochila = #{} // No puede tener mas de 3
	
	method modificarEnergia(unaCantidad) {
		energia = ( energia + unaCantidad ).max(0)
	} 
	
	method hayLugarEnMochila() = mochila.size() < 3
	method energiaSuficienteParaRecolectar(unMaterial) = energia >= unMaterial.energiaRequerida()
	
	method puedeRecolectar(unMaterial) = self.hayLugarEnMochila() and self.energiaSuficienteParaRecolectar(unMaterial)
	
	method validarRecoleccion(unMaterial){
		if (!self.puedeRecolectar(unMaterial)){
			self.error("No se puede recolectar " + unMaterial)
		}
	}
	
	method recolectar(unMaterial) {
		self.validarRecoleccion(unMaterial)
		mochila.add(unMaterial)
		unMaterial.efectoSobreRecolector(self)
	}
	
	method darObjetosA(unCompanero) {
		unCompanero.recibir(mochila)
		mochila.clear()
	}
}