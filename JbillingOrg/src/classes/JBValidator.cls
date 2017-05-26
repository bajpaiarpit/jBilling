public with sharing class JBValidator{

    public class CreditCardDetails
    {
        public string name {get;set;}
        public Integer[] length = new List<Integer>();
        public Integer[] prefix = new List<Integer>();
        public boolean checkdigit {get;set;}
        public string cardformat {get;set;}
        
            public CreditCardDetails(string name,Integer[] length,Integer[] prefix,boolean checkdigit,string cardformat)
            {
                this.name =name;
                this.length = length;
                this.prefix = prefix;
                this.checkdigit = checkdigit;
                this.cardformat = cardformat;
            }
    } 
    
    public Map<string,CreditCardDetails> xcarddetail {get;set;}// = new Map<string,CreditCardDetails>();
    public Map<Integer,string> carderror {get;set;} //= new Map<Integer,string>();
    public JBValidator()
    {
        xcarddetail = new Map<string,CreditCardDetails>();
        carderror = new Map<Integer,string>();
        
        xcarddetail = ReturnCardDetailList();
        
        carderror = returncarderror();
    }
    
        
    public static integer areacode {get;set;}
    public static integer countrycode {get;set;}
    public static string phonenum {get;set;}

    /*
        Formatting for sending phone numbers 
        to JBilling app in proper format
    */
    //set test format to parse (999) 999-12345
    //or 999 999-12345
    //or 99999999999
    public void FormatPhoneNumber(string phone)
    {   
        
        string[] strlist = Splitstring(phone);
        if(strlist.size()==1)
        {
            countrycode =null;
            areacode= null;
            phonenum = strlist[0];//Integer.ValueOf(strlist[0]);
        }
        
        else if(strlist.size()==2)
        {
            string[] split2wo = Splitstring(strlist[1]);
            if(split2wo.size()==1)
            {
                countrycode =null;
                areacode= Integer.ValueOf(strlist[0]);
                phonenum =strlist[1];//Integer.ValueOf(strlist[1]);
            }
            else if(split2wo.size()==2)
            {
                countrycode =Integer.ValueOf(PhoneCountryCode(strlist[0]));
                areacode = Integer.ValueOf(split2wo[0]);
                phonenum = strlist[1];//Integer.ValueOf(split2wo[1]);
            }
        }
        
        else if (strlist.size()==3)
        {
            countrycode =Integer.ValueOf(PhoneCountryCode(strlist[0]));
            areacode= Integer.ValueOf(strlist[1]);
            phonenum = strlist[2];//Integer.ValueOf(strlist[2]);
        }
        
    }
    public string[] Splitstring(string phone)
    {
        if(phone.contains(' '))
        {
            return phone.split(' ');
        }
        else if (phone.contains('-'))
        {
            return phone.split('-');
        }
        string[] strlist = new string[1];
        strlist[0] =  phone;
        return strlist;
    }
    
    
    public string PhoneCountryCode(string xareacode)
    {
        string sareacode;
        
        if(xareacode.contains('('))
        {
            integer startindex = xareacode.indexOf('(') +1;
            integer endindex = xareacode.indexOf(')');
            
            sareacode = xareacode.substring(startindex,endindex);
            return sareacode;
        }
        
        return xareacode;
    }
    
    //Credit Card Validation 
    
    //method to add data about credit cards and return list of 
    //class CreditCardDetails
    
    public Map<string,CreditCardDetails> ReturnCardDetailList()
    {
        /* Make a list of credit cards with length and starting codes */
        
        Map<string,CreditCardDetails> xMapret = new Map<string,CreditCardDetails>();
        
        xMapret.put('visa',new CreditCardDetails('Visa',new Integer[]{13,16},new Integer[]{4},true,'4111111111111111 or 4111-1111-1111-1111'));
        xMapret.put('mastercard',new CreditCardDetails('MasterCard',new Integer[]{16},new Integer[]{51,52,53,54,55},true,'5599000099990004 or 5500-0000-0000-0004'));
        xMapret.put('diners',new CreditCardDetails('Diners',new Integer[]{14,16},new Integer[]{30,36,38,54,55},true,'38520000023237 or 3852-0000-0232-37'));
        xMapret.put('amex',new CreditCardDetails('AmEx',new Integer[]{15},new Integer[]{34,37},true,'340000000000009 or 3400-0000-0000-009'));
        xMapret.put('discover',new CreditCardDetails('discover',new Integer[]{15,16},new Integer[]{6011,622,64,65},true,'6011000000000004 or 6011-0000-0000-0004'));
        xMapret.put('carteblanche',new CreditCardDetails('CarteBlanche',new Integer[]{14},new Integer[]{300,301,302,303,304,305},true,'3000 0000 0000 04 or 3000-0000-0000-04'));
        xMapret.put('jcb',new CreditCardDetails('JCB',new Integer[]{16},new Integer[]{35},true,'3530111333300000 or 3530-111333300000'));
        xMapret.put('enroute',new CreditCardDetails('enRoute',new Integer[]{15},new Integer[]{2014,2149},true,'201400000000009 or 2014-0000-0000-009'));
        xMapret.put('solo',new CreditCardDetails('Solo',new Integer[]{16,18,19},new Integer[]{6334,6767},true,'6334000000000004 or 6334-0000-0000-0004'));
        xMapret.put('switch',new CreditCardDetails('Switch',new Integer[]{16,18,19},new Integer[]{4903,4905,4911,4936,564182,633110,6333,6759},true,'4903010000000009 or 4903-0100-0000-0009'));
        //xMapret.put('maestro',new CreditCardDetails('Maestro',new Integer[]{12,13,14,15,16,18,19},new Integer[]{5018,5020,5038,6304,6759,6761,6762,6763},true));
        //xMapret.put('visaelectron',new CreditCardDetails('VisaElectron',new Integer[]{16},new Integer[]{4026,417500,4508,4844,4913,4917},true));
        xMapret.put('lasercard',new CreditCardDetails('LaserCard',new Integer[]{16,17,18,19},new Integer[]{6304,6706,6771,6709},true,'  6304100000000008 or 6304-1000-0000-0008'));
        
        return xMapret;
        
    }
    
    public Map<Integer,string> returncarderror()
    {
        Map<Integer,string> xccerror = new Map<Integer,string>();
        
        xccerror.put(1,'Unknown card type');
        xccerror.put(2,'No card number provided');
        xccerror.put(3,'Credit card number is in invalid format');
        xccerror.put(4,'Credit card number is invalid');
        xccerror.put(5,'Credit card number has an inappropriate number of digits');
        xccerror.put(6,'Warning! This credit card number is associated with a scam attempt');
        
        return xccerror;
    }
    
    public string validateCreditCard(string cardtype,string cardaddress)
    {
         cardaddress = cardaddress.replace('-','');
        boolean Lengthvalid;
        boolean PrefixValid;
        boolean undefined;
        integer carlen;
        
        //make this string while iterating to check 
        //available prefix
        string validprefix = '{ ';
        
        string errorstr;
        
        if(cardaddress != null && cardaddress != '')
        {
            carlen = cardaddress.length();
            CreditCardDetails card;
            if(cardtype != null){card = xcarddetail.get(cardtype.tolowercase());}
            if(card !=null)
            {
                for(integer i = 0; i<card.length.size();i++)
                {
                    if(carlen==card.length[i])
                    {Lengthvalid =true;
                    break;
                    }
                    else
                    {Lengthvalid = false;}
                }
                
                for(integer j=0 ;j<card.prefix.size();j++)
                { 
                    string tempprefix = string.ValueOf(card.prefix[j]);
                    
                    validprefix += tempprefix;
                    if(j != card.prefix.size()-1)
                    {validprefix +=' , ';}
                    if(j == card.prefix.size()-1)
                    {validprefix +=' }';}
                    
                    Integer tempPrefixlen = tempprefix.length();
                    system.debug('temp prefix'+tempPrefix);
                    system.debug('temp prefix len'+tempPrefixlen);
                    system.debug('card substring:'+cardaddress.substring(0,tempPrefixlen));
                    if(cardaddress.substring(0,tempPrefixlen) == tempprefix)
                    {PrefixValid = true;
                     break;
                    }
                    else
                    {PrefixValid= false;}
                    
                }
                
                //check if length is Ok
                if(!Lengthvalid)
                {
                    errorstr = carderror.get(5)+ '\r Format for '+card.name+' is '+card.cardformat;
                }
                if(!PrefixValid)
                {
                    errorstr = 'Invalid Prefix for '+card.name+'\r'+'Allowed prefix are '+validprefix;
                }
            }
        }
        
        return errorstr;
    }
    
    
}