using System;
using System.Security.Cryptography;
using System.Text;

public class Program
{
    public static void Main(string[] args)
    {
        Console.WriteLine("Mật khẩu: admin => Hashed: " + HashPassword("Admin"));
        //Admin: c1c224b03cd9bc7b6a86d77f5dace40191766c485cd55dc48caf9ac873335d6f
        //admin: 8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918

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