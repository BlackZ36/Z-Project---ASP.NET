using System;
using System.Security.Cryptography;
using System.Text;

public class Program
{
    public static void Main(string[] args)
    {
        Console.WriteLine("Mật khẩu: 123456 => Hashed: " + HashPassword("123456"));
        //Admin:            c1c224b03cd9bc7b6a86d77f5dace40191766c485cd55dc48caf9ac873335d6f
        //admin:            8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918
        //testingpassword:  9cf7d77d7bec9aa0ad492029e667720b5cc18c1eff1928a145ba6d96c5e7530a
        //Matkhaune123!:    bc52d96cd04c3910b4d996b67677df89d43a24db1e472f2a8032e11ef019a4e0
        //123456:           8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92
    }

    public static string HashPassword(string password)
    {
        using (SHA256 sha256 = SHA256.Create())
        {
            // Convert password string to byte array
            byte[] passwordBytes = Encoding.UTF8.GetBytes(password);

            // Compute hash value of the password bytes
            byte[] hashBytes = sha256.ComputeHash(passwordBytes);

            // Convert byte array to a string
            StringBuilder builder = new StringBuilder();
            for (int i = 0; i < hashBytes.Length; i++)
            {
                builder.Append(hashBytes[i].ToString("x2")); // Convert byte to hexadecimal string
            }

            return builder.ToString();
        }
    }

}