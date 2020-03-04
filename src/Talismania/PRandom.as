package Talismania 
{
	/**
	 * ...
	 * @author Skillcheese
	 */
	public class PRandom 
	{
	   {
		  private var seed1:int;
      
		  private var seed2:int;
		  
		  private var seed3:int;
		  
		  private var seed4:int;
		  
		  private var lastWheelStep:int;
		  
		  private var wheel1:Array;
		  
		  private var wheel2:Array;
		  
		  private var wheel3:Array;
		  
		  private var wheel4:Array;
		  
		  private var lastWheel:Array;
		  
		  public function PRandom() 
		  {
			  this.wheel1 = [0,8,1,2,7,3,6,4,5,4,3,2,6,1,7,6,7,5,8,3,5,4,6,2,3,2,7,8,4,6,0,0,1,0,5,7,4,8,9,7,6,5,4,5,2,3,4,8,7,6,2,1,5,2,1,6,0,7,2,1,8,7,4,0,6,3,1,8,7,5,2,3,4,8,7,2,8,7,6,0,4,5,0,8,7,2,4,0,7,3,6,2,1,3,4,1,0,7,3,0,9,7,2];
			  this.wheel2 = [6,5,4,0,3,4,3,7,1,2,6,5,3,4,1,5,1,4,3,5,7,1,6,3,5,4,1,3,7,3,4,5,7,4,2,3,9,5,2,3,6,3,8,9,2,5,7,3,6,2,3,1,4,9,2,3,1,4,6,2,1,4,2,5,2,1,8,7,2,4,7,6,2,5,4,5,2,3,7,6,9,7,9,6,9,0,5,3,1,6,9,0,6,5,1,9,1,7,0,4,5,8,6];
			  this.wheel3 = [5,6,2,0,6,4,8,9,2,4,5,2,1,3,4,9,7,9,4,0,2,4,2,9,4,1,2,3,5,4,7,2,1,4,8,6,9,2,3,4,6,5,0,9,9,4,1,0,5,6,0,2,6,7,4,8,2,3,8,1,4,9,0,5,6,4,5,0,8,9,0,4,9,0,2,9,5,2,0,8,4,2,3,0,4,2,0,9,4,9,1,0,4,5,3,0,2,8,9,4,6,5,1];
			  this.wheel4 = [9,4,0,2,4,2,9,4,1,2,3,5,4,7,2,1,5,6,2,0,6,4,8,9,2,4,5,2,1,3,4,9,7,1,0,5,6,4,8,6,9,2,3,4,6,5,0,9,9,4,0,2,4,9,0,5,6,4,5,0,8,9,0,4,9,0,2,9,5,2,0,8,4,2,3,6,7,4,8,2,3,8,1,5,3,0,2,8,9,4,6,5,1,0,4,2,0,9,4,9,1,0,4];
			  this.lastWheel = [5,4,8,7,5,7,8,2,1,4,6,4,3,4,5,6,3,7,5,4,3,5,6,1,6,1,3,4,2,5,8,3,4,5,8,2,3,7,8,5,6,4,3,0,9,3,8,1,7,3,9,8,2,1,6,4,9,2,8,7,2,3,4,5,0,1,5,0,1,7,3,0,2,6,5,0,1,5,0,1,2,3,7,6,5,2,3,4,8,7,5,5,8,8,5,8,7,0,1,1,2,3,2];
		  }
		  
		  public function setSeed(pSeed:Number = NaN) : void
		  {
			 if(isNaN(pSeed))
			 {
				pSeed = Math.random() * 100000000;
			 }
			 if(pSeed < 0)
			 {
				pSeed = pSeed * -1;
			 }
			 pSeed = Math.round(pSeed);
			 pSeed = pSeed % 100000000;
			 this.seed1 = Math.floor(pSeed / 1000000);
			 this.seed2 = Math.floor(pSeed / 10000) % 100;
			 this.seed3 = Math.floor(pSeed / 100) % 100;
			 this.seed4 = Math.floor(pSeed) % 100;
			 this.lastWheelStep = 0;
		  }
		  
		  public function getRnd() : Number
		  {
			 return this.getDigit() * 0.0021 + this.getDigit() * 0.0932 + this.getDigit() * 0.0145;
		  }
		  
		  private function getDigit() : int
		  {
				 this.seed4++;
				 if(this.seed4 > 99)
				 {
					this.seed4 = 0;
					this.seed3++;
					if(this.seed3 > 99)
					{
					   this.seed3 = 0;
					   this.seed2++;
					   if(this.seed2 > 99)
					   {
						  this.seed2 = 0;
						  this.seed1++;
						  if(this.seed1 > 99)
						  {
							 this.seed1 = 0;
						  }
					   }
					}
				 }
				 this.lastWheelStep++;
				 if(this.lastWheelStep > 101)
				 {
					this.lastWheelStep = 0;
				 }
				 return (this.wheel1[this.seed1] + this.wheel2[this.seed2] + this.wheel3[this.seed3] + this.wheel4[this.seed4] + this.lastWheel[this.lastWheelStep]) % 10;
		  }
	   }
	}
}