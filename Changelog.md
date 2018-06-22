# Changelog

## Game
1. Created GenServer to process all the information related to a game, there's no need for a table as for now.
2. There is a method to manually stop Game processes or automatically do so after 1 hour of inactivity, this is to prevent having unused processes around
3. Players can be added to Game process, an error is returned when a player already exists in the game. It should be a good idea to identify each player by ID so we don't rely on the whole struct attributes to do verification.
