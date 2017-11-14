/*Estrategia para elegir los materiales de la mochila */
class Estrategia {	
	/*Devuelve algun material de la mochila. */
	method algunMaterialQueCumpla(mochila)	
}

/*Al azar: Se elige cualquier elemento de la mochila*/
object azar inherits Estrategia{
	override method algunMaterialQueCumpla(mochila) = mochila.anyOne()
} 

/*Menor cantidad de metal: Se elige de entre todos los elementos, 
 * aquel que tiene la menor cantidad de metal.*/
object menorMetal inherits Estrategia{
	override method algunMaterialQueCumpla(mochila) = mochila.min{m => m.gramosDeMetal()}
}

/*Mejor generador eléctrico: Se elige de entre todos los elementos, 
 * aquel que produce la mayor cantidad de energía */ 
object mejorGenerador inherits Estrategia{
	override method algunMaterialQueCumpla(mochila) = mochila.max{m => m.energia()}
}

/*Ecológico: De entre todos los elementos, intenta utilizar un ser vivo. 
 * En caso de que ninguno lo sea, intenta usar un elemento que no sea radiactivo.*/
object ecologico inherits Estrategia{

	override method algunMaterialQueCumpla(mochila) = 
		mochila.findOrElse({m => m.estaVivo()}, {
			mochila.findOrElse({m => !m.esRadiactivo()}, {
				mochila.anyOne()
			})
		})
}