#define switches (volatile char *) 0x0002010
#define leds (char *) 0x0002000
void main(){
	//char str[7];
	while (1)
	*leds = *switches;
/* 	strcpy(str , "0000");
	strcat(str, switches);
	*leds = str; */
}