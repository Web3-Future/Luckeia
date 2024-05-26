import { Navbar, NavbarBrand, NavbarContent, NavbarItem, Link, Button, Spacer } from "@nextui-org/react";
import { AcmeLogo } from "../../public/LuckyChainLogo.jsx";
import TabsDemo from "../../components/TabsDemo"
export default function Home() {
  return (
    <main className="">
      <div className="w-full h-[100vh]">
        <Navbar className="absolute text-white top-0 z-50 w-full flex items-center">
          <NavbarBrand>
            <AcmeLogo />
            <p className="font-bold text-inherit">Luckeia</p>
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
            {/* <Spacer /> */}
            <NavbarItem>
              <w3m-button />
            </NavbarItem>
          </NavbarContent>
          {/* <NavbarContent className="hidden sm:flex">
            <NavbarItem>
              <w3m-button />
            </NavbarItem>
          </NavbarContent> */}
        </Navbar>
        {/* <h1 className="text-6xl font-bold text-white absolute top-[30%] left-1/2 transform -translate-x-1/2">
          Connect everything. <br />
          Build anything.
        </h1> */}
        {/* <h1 className="absolute top-[30%] left-1/2 transform -translate-x-1/2">Lucky Chain</h1> */}
        <div className="absolute top-[20%] left-1/2 transform -translate-x-1/2 z-40">
          <TabsDemo />
        </div>
        <iframe className="w-full h-full" src="/index.html">
        </iframe>

      </div>
      {/* <footer className="w-full h-24 flex items-center justify-center border-t">
        <p>Lucky Chain</p>
      </footer> */}
    </main>
  );
}
