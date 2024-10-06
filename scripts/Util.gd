extends Node
enum EnemyType {
    ANT,
    CATERPILLAR,
    FLY
}

func get_enemy(enemy_type : EnemyType) -> PackedScene:
    match enemy_type:
        EnemyType.ANT:
            return Refs.ant_scene
        # EnemyType.CATERPILLAR:
        #     return Caterpillar
        # EnemyType.FLY:
        #     return Fly
        _:
            return null
