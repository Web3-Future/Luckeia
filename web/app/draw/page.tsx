import { Navbar, NavbarBrand, NavbarContent, NavbarItem, Link, Button } from "@nextui-org/react";
import { AcmeLogo } from "../../public/LuckyChainLogo.jsx";
export default function Home() {
  return (
    <main className="">
      <div className="w-full h-[100vh]">
        <Navbar className="absolute top-0 z-50 w-full flex items-center">
          <NavbarBrand>
            <AcmeLogo />
            <p className="font-bold text-inherit">ACME</p>
          </NavbarBrand>
          <NavbarContent className="hidden sm:flex gap-4" justify="center">
            <NavbarItem>
              <Link color="foreground" href="/draw">
                Draw
              </Link>
            </NavbarItem>
            <NavbarItem isActive>
              <Link href="/about" aria-current="page">
                About
              </Link>
            </NavbarItem>
            <NavbarItem>
              <Button as={Link} color="primary" href="#" variant="flat">
                Sign Up
              </Button>
            </NavbarItem>
          </NavbarContent>
        </Navbar>
        <iframe className="w-full h-full" src="/index.html">
        </iframe>
      </div>
    </main>
  );
}
